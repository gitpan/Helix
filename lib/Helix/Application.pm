package Helix::Application;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Application.pm - application class
#
# ==============================================================================

use Helix::Core::Exception::List;
use Helix::Core::Registry;
use Helix::Core::Driver::Loader;
use Helix::Core::CGI;
use Helix::Core::Router;
use warnings;
use strict;

our $VERSION = "0.01"; # 2008-10-17 23:22:54

# application interface types
use constant
{
    "TYPE_CGI"  => 0,
    "TYPE_FCGI" => 1
};

# ------------------------------------------------------------------------------
# \% new($type)
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $type, $self);

    ($class, $type) = @_;

    $self = {};
    bless $self, $class;
    $self->_init($class, $type || $self->TYPE_CGI);

    return $self;
}

# ------------------------------------------------------------------------------
# _init($name, $type)
# application initialization
# ------------------------------------------------------------------------------
sub _init
{
    my ($self, $name, $type, $r, $config);

    ($self, $name, $type) = @_;

    eval
    {
        local $SIG{"__DIE__"} = sub 
        {
            $_[0]->rethrow if ($_[0] eq "Exception");
            throw Exception($_[0]);
        };

        $r = Helix::Core::Registry->new;
        $config = "$name\::Config";

        # load config
        {
            local $SIG{"__DIE__"} = sub {};
            eval "require $config";
        }

        throw Error::Core::Compile($@) if ($@);

        $r->{"cfg"} = $config->new($name, $type);
    };

    # config loading failed, giving up
    if ($@)
    {
        print "Content-Type: text/html\n\n";
        die $@;
    }
}

# ------------------------------------------------------------------------------
# handle_request()
# handle HTTP request
# ------------------------------------------------------------------------------
sub handle_request
{
    my ($self, $r, $e, $ctrl, $action);

    $self = shift;
    $r    = Helix::Core::Registry->get_instance;

    eval 
    { 
        local $SIG{"__DIE__"} = sub 
        {
            $_[0]->rethrow if ($_[0] eq "Helix::Core::Exception");
            throw Helix::Core::Exception($_[0]);
        };

        # some useful classes
        $r->{"cgi"}    = Helix::Core::CGI->new;
        $r->{"driver"} = Helix::Core::Driver::Loader->new;
        $r->{"router"} = Helix::Core::Router->new;

        # find and start a request handler
        $r->{"router"}->find_handler;
        &{ $r->{"router"}->{"handler"} };
    };

    # if something went wrong
    if ($@) 
    {
        $ctrl = "$r->{'cfg'}->{'app'}->{'name'}::Controller::_Error";
        $r->{"router"}->{"controller"} = $ctrl;
        $e = $@;

        eval "require $ctrl";
        throw Error::Core::DoubleFault($@) if ($@);

        # error handler
        (!$action) && $ctrl->action_cache->{"Error"} && ($action = "Error");
        (!$action) && die $e;

        &{ $ctrl->action_cache->{$action} }($e);
    }

    # cleanup
    undef $r->{"router"};
    undef $r->{"driver"};
    undef $r->{"cgi"};
}

1;

__END__

=head1 NAME

Helix::Application - Helix Framework application base class.

=head1 SYNOPSIS

Example application package (C<lib/Example/Application.pm>):

    package Example::Application;
    use base qw/Helix::Application/;

    our $VERSION = "0.01";

CGI application gateway (C<index.cgi>):

    use lib "./lib";
    use Example::Application;

    my $app = Example::Application->new(Example::Application->TYPE_CGI);
    $app->handle_request;

=head1 DESCRIPTION

The I<Helix::Application> class is the base high-level class of a usual 
I<Helix Framework> application. It creates various system objects, reads 
application configuration and handles user requests. 

Should never be used directly, subclass it from your application's 
C<Application.pm> instead.

=head2 Request processing flow

These steps are performed while processing user request. This sequence can be 
redefined by the ancestor class, but in most cases you won't need to do this.

=over 4

=item 1. Create system registry

Registry is the system information structure. This step is done first, because
other parts of the system depend on the registry. For more information see 
L</Mount points> section below and 
L<Helix::Core::Registry> module documentation.

=item 2. Load application configuration

In this step application loads and instantiates the application configuration 
class. It contains all basic system settings. Application configuration in
example application would be stored in C<lib/Example/Config.pm>. For more 
information see L<Helix::Core::Config>.

=item 3. Accept requests (I<FastCGI application only>!)

FastCGI application works like a I<daemon> - it resides in memory, accepting
connections from the web server. Whence a new connection is established, 
the application goes to the next step.

=item 4. Handle request

Actually, all the work is done in this step. First of all, the application
creates the L<Helix::Core::CGI> object, that is used 
to process all incoming data. Next, application loads system drivers using the
L<Helix::Core::Driver::Loader> object. The list 
of required drivers must be specified in the application configuration. 
Afterwards, the L<Helix::Core::Router> package comes to
action. It tries to find the request handler and transfers execution to it or
to the error handler, if something went wrong.

After request (or error) handling, a CGI application shuts down, but FastCGI
application goes next.

=item 5. Go to step #3 (I<FastCGI application only>!)

When a user request is handled, our I<daemon>-like application is ready to
serve another clients I<without termination>, so we save a bit of system
resources.

=back

=head2 Mount points

During initialization and request handling application mounts each vital object
to system registry to allow other application parts to use it later. This is the
list of all mount points, that are created by I<Helix::Application> (C<$r> below
stands for L<Helix::Core::Registry> instance):

=over 4

=item $r->{"cfg"}

Application configuration object (see L</Load application configuration> section 
above and L<Helix::Core::Config> module documentation).

=item $r->{"cgi"}

CGI object (see L<Helix::Core::CGI> for more information).

=item $r->{"driver"}

Driver loader object (see 
L<Helix::Core::Driver::Loader>).

=item $r->{"router"}

Request router object (see L<Helix::Core::Router> for more
information).

=back

Of course, you can mount other objects to the registry while overloading one of
I<Helix::Application> methods, though it's not recommended. 

=head1 METHODS

=head2 new($type)

Class constructor. Creates an object and calls the application initialization
function. C<$type> - application type (see L</CONSTANTS>).

=head2 _init($name, $type)

Application initialization. Creates system registry and loads application
configuration. C<$name> is the application name, C<$type> - application type.

=head2 handle_request()

User request processing. This function parses and routes the request, then it
transfers execution to request handler. If any exception occurs during 
processing, it tries to start application's error handler. If no such handler 
was found, application dies.

=head1 CONSTANTS

=head2 TYPE_CGI

CGI application is the default type. It is suitable for development purposes
(L<Helix::Debug> will work only with this application type) and 
low-loaded applications. When this type is used, the web server starts one 
interpreter instance per user request, so if you issue high CPU usage or high
memory load - use the following application type.

=head2 TYPE_FCGI

FastCGI application type is suitable for high-loaded applications with a lot
of concurrent connections. It's faster than CGI I<up to 2000%>. This type 
suggests L<FCGI> module to be installed, otherwise application won't work. Also,
this type has one significant limitation - you are unable to use 
I<Helix Framework> debugging facility (L<Helix::Debug>) with this 
type, so use C<TYPE_CGI> during development.

=head1 SEE ALSO

L<Helix>, L<Helix::Debug>, 
L<Helix::Core::Registry>,
L<Helix::Core::Config>,
L<Helix::Core::CGI>,
L<Helix::Core::Driver::Loader>,
L<Helix::Core::Router>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
