package Helix::Core::Registry;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Registry.pm - global registry
#
# ==============================================================================

use warnings;
use strict;

our ($VERSION, $INSTANCE);

$VERSION  = "0.01"; # 2008-10-17 23:23:16
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

1;

__END__

=head1 NAME

Helix::Core::Registry - global data storage for Helix Framework.

=head1 SYNOPSIS

Somewhere in application controllers:

    my $r = Helix::Core::Registry->get_instance;
    $r->{"cgi"}->send_header;

    my $tpl = $r->{"driver"}->object(DT_TEMPLATE);
    $tpl->parse("index.tpl");
    $tpl->render;

=head1 DESCRIPTION

The I<Helix::Core::Registry> class creates a global data storage hash for the
whole I<Helix Framework> application. It is instantiated and filled in during
applicaton initialization and request processing flow. You can use it anywhere
in application.

In other modules' documentation examples I<Helix::Core::Registry> is referred as
C<$r> variable.

=head1 METHODS

=head2 new()

Class constructor. Creates global data storage.

=head2 get_instance()

Returns registry instance. Class must be instantiated first.

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

