package Helix::Core::Registry;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Registry.pm - global registry
#
# ==============================================================================

use base qw/Class::Accessor::Fast/;
use warnings;
use strict;

__PACKAGE__->mk_accessors(qw/cgi config loader/);

our ($VERSION, $INSTANCE);

$VERSION  = "0.02"; # 2009-05-12 06:28:11
$INSTANCE = undef;

# ------------------------------------------------------------------------------
# \% new()
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $self);

    $class = shift;
    $self  = {};
    bless  $self, $class;
    $INSTANCE = $self;

    return $self;
}

# ------------------------------------------------------------------------------
# \% get_instance()
# get instance
# ------------------------------------------------------------------------------
sub get_instance
{
    return $INSTANCE;
}

# ------------------------------------------------------------------------------
# free()
# free variables
# ------------------------------------------------------------------------------
sub free
{
    delete $_[0]->{"cgi"};
    delete $_[0]->{"loader"};
}

1;

__END__

=head1 NAME

Helix::Core::Registry - global data storage for Helix Framework.

=head1 SYNOPSIS

Somewhere in application controllers:

    my $r = Helix::Core::Registry->get_instance;
    $r->cgi->send_header;

    my $tpl = $r->loader->get_object("Helix::Driver::Template");
    $tpl->parse("index.tpl");
    $tpl->render;

=head1 DESCRIPTION

The I<Helix::Core::Registry> class creates a global data storage object for the
whole I<Helix Framework> application. It is instantiated and filled in during
applicaton initialization and request processing flow. You can use it anywhere
in application.

In I<Helix Framework> documentation examples I<Helix::Core::Registry> is 
referred as C<$r> variable.

=head2 Mount points

During initialization and request handling application mounts each vital object
to system registry to allow other application parts to use them later. This is the
list of all mount points, that are created by I<Helix::Application>:

=over 4

=item $r->config

Application configuration object (see 
L<Helix::Application/Load application configuration> and L<Helix::Core::Config> 
module documentation).

=item $r->cgi

CGI object (see L<Helix::Core::CGI> for more information).

=item $r->loader

Driver loader object (see L<Helix::Core::Loader> documentation).

=back

=head1 METHODS

=head2 new()

Class constructor. Creates global data storage.

=head2 get_instance()

Returns registry instance. Class must be instantiated first.

=head2 free()

Destroys L<Helix::Core::CGI> and L<Helix::Core::Loader> objects.

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

