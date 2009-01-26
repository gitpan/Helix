package Helix::Core::Router;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Router.pm - query router
#
# ==============================================================================

use Helix::Core::Driver::Types;
use List::Util qw/first/;
use warnings;
use strict;

our $VERSION  = "0.01"; # 2008-10-17 23:23:06

# ------------------------------------------------------------------------------
# \% new()
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $self);

    $class = shift;

    # class attributes
    $self  = 
    {
        "query"      => undef,  # HTTP-query
        "controller" => undef,  # selected controller
        "handler"    => undef,  # handler reference
        "params"     => undef   # parameters list reference
    };

    bless $self, $class;

    return $self;
}

# ------------------------------------------------------------------------------
# \@ _parse_query($query)
# query parsing
# ------------------------------------------------------------------------------
sub _parse_query
{
    my ($self, $query, $query_len);

    ($self, $query) = @_;
    
    # query might be empty
    if ($query) 
    {
        $query_len = length($query);

        if ( index($query, "/") == 0)              { substr($query, 0, 1)              = "" }
        if (rindex($query, "/") == $query_len - 1) { substr($query, $query_len - 1, 1) = "" }
    }

    $self->{"query"} = $query;

    return $query ? [ split /\//, $query ] : undef;
}

# ------------------------------------------------------------------------------
# _find_controller($items)
# find controller
# ------------------------------------------------------------------------------
sub _find_controller
{
    my ($self, $items, $r, $ctrl, $ctrl_path, $module);

    ($self, $items) = @_;

    $r         = Helix::Core::Registry->get_instance;
    $ctrl      = "";
    $ctrl_path = "./lib/$r->{'cfg'}->{'app'}->{'name'}/Controller/";

    # compose controller's name
    while ($_ = shift(@$items)) 
    {
        $module = ucfirst($_);
        $ctrl_path .= "/$module";
        
        if (-d $ctrl_path) 
        {
            $ctrl .= "::$module";
        } 
        elsif (-f "$ctrl_path.pm" && ($module ne "Default" || $ctrl) && ($module ne "_Error" || $ctrl)) 
        {
            $ctrl .= "::$module";
            last;
        } 
        else 
        {
            unshift(@$items, $_);
            last;
        }
    }

    $ctrl = "::Default" if (!$ctrl);
    $self->{"controller"} = "$r->{'cfg'}->{'app'}->{'name'}::Controller".$ctrl;
}

# ------------------------------------------------------------------------------
# _find_action($items)
# find action
# ------------------------------------------------------------------------------
sub _find_action
{
    my ($self, $r, $items, $handler, $ctrl, $action, @params);

    ($self, $items) = @_;
    $action  = ($items && (@$items > 0)) ? join("/", @$items) : undef;
    $handler = undef;
    $ctrl    = $self->{"controller"};
    $r       = Helix::Core::Registry->get_instance;

    {
        local $SIG{"__DIE__"} = sub {};
        eval "require $ctrl";
    }

    throw Error::Core::Compile($@) if ($@);

    # find action
    if ($action) 
    {
        $handler = first 
        { 
            /^Action\(['|"]?(.+?)['|"]?\)$/o && 
            (@params = $action =~ /^$1$/) 
        } keys %{ $ctrl->action_cache };

        # if handler was found
        if ($handler)
        {
            $handler = $ctrl->action_cache->{$handler};

            # delete undefined parameters
            foreach (0 .. $#params)
            {
                delete $params[$_] unless (defined $params[$_]);
            }

            $self->{"params"} = \@params;
        }
    } 
    else
    {
        $handler = $ctrl->action_cache->{"Default"};
    }

    throw Error::Core::Router::NotFound  if (!$handler);
    throw Error::Core::Router::Forbidden if 
    (
        $r->{"driver"}->is_loaded(DT_USER)                 && 
       !$r->{"driver"}->get_object(DT_USER)->is_authorized && 

        (
            (
                $r->{"cfg"}->{"app"}->{"policy"} eq "private" &&
                !first { /^Public$/ } @{ $ctrl->attr_cache->{$handler} }
            ) ||

            first { /^Private$/ } @{ $ctrl->attr_cache->{$handler} }
        )
    );

    $self->{"action"}  = $action;
    $self->{"handler"} = $handler;
}

# ------------------------------------------------------------------------------
# find_handler()
# find query handler
# ------------------------------------------------------------------------------
sub find_handler
{
    my ($self, $r, $items);

    $self  = shift;
    $r     = Helix::Core::Registry->get_instance;

    $items = $self->_parse_query( $r->{"cgi"}->get("query") );
    $self->_find_controller($items);
    $self->_find_action($items);
}

1;

__END__

=head1 NAME

Helix::Core::Router - request router for Helix Framework.

=head1 SYNOPSIS

Somewhere in application controllers:

    my $r = Helix::Core::Registry->get_instance;
    my $router = $r->{"router"};

    print "GET-query:  ".$router->{"query"}."\n";
    print "Controller: ".$router->{"controller"}."\n";
    print "Parameters: ".join(", ", @{ $router->{"params"} })."\n";

=head1 DESCRIPTION

The I<Helix::Core::Router> class finds handler for each user request. Routing
is based on controller names and method attributes.

=head2 Routing flow

=over 4

=item * Query parsing

First, this package parses I<query> GET-parameter value. This string is splitted
by I</> character and results are placed to array.

=item * Searching controller

Each part of I<query array> is sequentally checked if it has got a corresponding
directory or file in C<lib/Example/Controller/> directory (I<Example> here should
be substituted with your application's name). For example, the query was 
I</it/is/full/of/stars/>. So, on this step router checks if 
C<lib/Example/Controller> has one of this files: C<It.pm>, C<It/Is.pm>, 
C<It/Is/Full.pm>, C<It/Is/Full/Of.pm>, C<It/Is/Full/Of/Stars.pm>, sequentally.

While I<query array> correlates file system structure, router keeps
searching, but when I<query array> item mismatches directory structure, it stops
and makes final controller path. For example, if router stopped at 
C<It/Is/Full.pm>, the final controller path will be 
C<Example::Controller::It::Is::Full>.

If the router stopped after realising that C<It.pm> file doesn't exist - it
tries to use fallback (default) page instead 
(C<lib/Example/Controller/Default.pm>).

The rest of I<query array> is used during the next step.

=item * Searching handler

Here router tries to load selected controller, and if any error occurs, 
throws an 
L<Helix::Core::Exception::List/Error::Core::Compile> 
exception. Then, it makes an action string from the rest of I<query array> by 
joining it with I</> character as a glue. For example, if I<query array> 
contained I<"full", "of", "stars">, the action becomes I<full/of/stars>. Now 
router checks every method in selected controller if it has got the 
C<Action($re)> code attribute with C<$re> regular expression, that matches 
selected action. If regex matches, this method is what router needs. 

If regular expression contained elements enclosed in round braces I<()>, these
elements assumed to be method parameters.

If action is empty (no elements in the I<query array>), router tries to use a
method with C<Default> code attribute.

After handler was found, router checks its security policy. If application
was defined as I<private> in configuration 
(see L<Helix::Core::Config> for more information) and a
handler doesn't have C<Public> code attribute - 
L<Helix::Core::Exception::List/Error::Core::Router::Forbidden>
exception is thrown. Also, this exception is thrown if a handler has got 
a C<Private> code attribute, without application configuration dependencies.

If router doesn't find matching method, 
L<Helix::Core::Exception::List/Error::Core::Router::NotFound>
exception is thrown.

=back

=head2 Method attributes

Method attributes used to show router which method is responsible for which 
query. These attributes can combine, i.e. C<Default> attribute could be mixed
with C<Action> and access attributes to extend query coverage that is handled
by this method.

=over 4

=item * Default

Routing attribute. Specifies the default page of the controller. It will be 
called if no action is defined for the controller. Actually, only one C<Default>
attribute should exist in one controller, though no one controls this. You can
have multiple C<Default>-marked methods in single controller, but which one will
be called... only God (and, possibly, Larry) knows.

=item * Action("regex")

Routing attribute. Specifies regular expression that should be matched by query.
C<regex> is a usual perl regular expression without starting and ending 
delimiters. You can use round braces I<()> to specify which parameters you want
to be used in method. These parameters could be accessed later (see
L</params> below). 

=item * Public

Security attribute. Specifies that the page that is handled by method should be
viewed by anyone, even if application is defined as I<private>.

=item * Private

Security attribute. Specifies that the page that is handled by method should not
be viewed by unauthorized user, even if application is defined as I<public>. To
make this feature work you need to have at least one user driver installed and 
this driver should be loaded and accessible as a C<DT_USER> driver (see
L<Helix::Core::Driver::Types> for more information).

=back

=head1 METHODS

=head2 new()

Class constructor. Creates router object.

=head2 _parse_query()

Parses GET query and returns reference to array of query items.

=head2 _find_controller($items)

Finds controller for request handling. C<$items> - reference to array of query
items.

=head2 _find_action($items)

Finds handler code reference in selected controller. C<$items> - reference to
array of query items.

=head2 find_handler()

Finds handler for particular request. 

=head1 ATTRIBUTES

The I<Helix::Core::Router> package has got several useful class attributes that
filled in during request routing. These variables could be accessed through
router object using hashref syntax:

    my ($r, $query, $params);

    $r      = Helix::Core::Registry->get_instance;
    $query  = $r->{"router"}->{"query"};
    $params = $r->{"router"}->{"params"};

=head2 query

HTTP I<query> parameter, that was transferred through GET request.

=head2 controller

Contoller class name, that was selected for request handling.

=head2 handler

Handler code reference in selected controller.

=head2 params

Reference to array of handler parameters. For example, if the method is
C<sub example : Action("news/(\d+)/(\w+)/)">, and query is I</news/17/oops/>, 
this array will contain two elements - I<17> and I<oops>.

=head1 SEE ALSO

L<Helix>, L<Helix::Applicaton>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
