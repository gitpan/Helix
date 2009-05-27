package Helix::Driver;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver.pm - generic driver
#
# ==============================================================================

use warnings;
use strict;

our $VERSION = "0.02"; # 2009-05-12 05:58:42

1;

__END__

=head1 NAME

Helix::Driver - Helix Framework generic driver.

=head1 SYNOPSIS

Example driver:

    package ExampleDrv;
    use base qw/Helix::Driver/;

    # ...

Somewhere in application:

    my ($r, $example);

    $r = Helix::Core::Registry->get_instance;
    $example = $r->loader->get_object("ExampleDrv");
    $example->wow("It works!");

=head1 DESCRIPTION

The I<Helix::Driver> is a base driver for all I<Helix Framework> drivers. 

=head1 SEE ALSO

L<Helix>, L<Helix::Core::Loader>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
