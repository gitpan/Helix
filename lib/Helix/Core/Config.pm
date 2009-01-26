package Helix::Core::Config;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Config.pm - system config
#
# ==============================================================================

use Cwd qw/getcwd/;
use warnings;
use strict;

our ($VERSION, $INSTANCE);

$VERSION  = "0.01"; # 2008-10-17 23:26:51
$INSTANCE = undef;

# ------------------------------------------------------------------------------
# \% new($name, $type)
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $name, $type, $self);

    ($class, $name, $type) = @_;

    # class attrubutes
    $self = 
    { 
        # application settings
        "app" =>
        {
            "title"    => undef,
            "name"     => $name,
            "version"  => $name->VERSION,
            "root_dir" => getcwd(),
            "type"     => $type,
            "policy"   => "private"
        },

        # CGI settings
        "cgi" => 
        {
            "max_post_size"  => 600000,
            "tmp_dir"        => "/tmp/",
            "charset"        => "UTF-8",
            "content_type"   => "text/html",
            "session_cookie" => "SESSIONID"
        },

        # driver list
        "drivers" => []
    };

    bless $self, $class;
    $INSTANCE = $self;

    return $self;
}

# ------------------------------------------------------------------------------
# \% get_instance()
# get config instance
# ------------------------------------------------------------------------------
sub get_instance
{
    return $INSTANCE;
}

1;

__END__

=head1 NAME

Helix::Core::Config - Helix Framework generic application configuration.

=head1 SYNOPSIS

Example application configuration (C<lib/Example/Config.pm>):

    package Example::Config;
    use base qw/Helix::Core::Config/;

    our $VERSION  = "0.1";

    sub new
    {
        my ($class, $name, $type, $self);

        ($class, $name, $type) = @_;

        $self = $class->SUPER::new($name, $type);
        $self->{"app"}->{"title"} = "Example application";

        $self->{"drivers"} = 
        [
            {
                "class" => "Helix::Driver::Template::HTML",
                "points" => [ "tpl" ],
                "params" => [ "./templates/" ]
            }
        ];

        return $self;
    }

=head1 DESCRIPTION

The I<Helix::Core::Config> class holds common configuration for all 
I<Helix Framewok> applications. Each application configuration should inherit 
this class and redefine generic parameters. This class should never be used 
directly.

=head2 Application configuration section

Main application settings are specified in C<{"app"}> item of configuration 
hash. This item contains a hashref of application settings:

=over 4

=item * title

Application title. Affects nothing, but could be useful in application design.

=item * name

Application class name. Determined automatically, you should not change this 
manually, otherwise something strange and bad can happen.

=item * version

Application version. Affects nothing, but could be useful sometimes. Value is
inserted automatically, if your C<Application.pm> has C<our $VERSION> variable
defined.

=item * root_dir

Application root directory. Determined automatically by executing C<getcwd()>.
You can redefine this manually, if you need. This value isn't used for internal
needs.

=item * type

Application type. Is determined automatically. I<Do not change it manually>!

=item * policy

Application security policy. Can have two possible values: I<public> or 
I<private>. The default is I<private>. In I<public> application anyone can
view any page, if page method has no C<Private> code attribute. In I<private>
application only authorized users can view pages, if page method has no 
C<Public> code attribute.

=back 

=head2 CGI configuration section

CGI settings are specified in C<{"cgi"}> item of configuration hash. This item 
contains a hashref of CGI settings:

=over 4

=item * max_post_size

Maximal POST request length, in bytes. The default value is I<600000>.

=item * tmp_dir

Directory path for saving temporary files and session data. The default value 
is I</tmp/>.

=item * charset        

General application charset. The default value is I<UTF-8>.

=item * content_type

General application content type. The default value is I<text/html>.

=item * session_cookie

Application session cookie name. The default value is I<SESSIONID>.

=back

=head2 Drivers configuration section

Drivers configuration is specified in C<{"drivers"}> item of a configuration 
hash. This item is the reference to array of hashrefs, each hashref represents
one driver configuration. Hashref items are:

=over 4

=item * class

Driver class name. 

=item * points

Reference to array of mount points. If no points specified, driver will not be
instantiated and you should do this manually later in controller code. 

=item * params

Reference to array of driver initialization parameters. This parameters will be
sent to driver constructor during driver initialization. 

=back

=head1 METHODS

=head2 new($name, $type)

Class constructor. Creates generic configuration for application C<$name> of
C<$type> type.

=head2 get_instance()

Returns configuration instance. Class must be instantiated first.

=head1 SEE ALSO

L<Helix>, L<Helix::Application>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
