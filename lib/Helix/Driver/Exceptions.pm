package Helix::Driver::Exceptions;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/Exceptions.pm - driver exceptions
#
# ==============================================================================

use warnings;
use strict;

our $VERSION = "0.02"; # 2009-05-14 05:20:08

use Helix::Core::Exception::Builder 
(
    "HXError::Driver" => 
    {
        "title" => "Driver error"
    },

);

1;

__END__

=head1 NAME

Helix::Driver::Exceptions - Helix Framework driver exceptions.

=head1 SYNOPSIS

In error handler of your application (C<lib/Example/Error.pm>) you could write:

    if ($e eq "HXError::Driver")
    {
        print "Driver error occured!";
    }
    else
    {
        $e->rethrow();
    }

=head1 DESCRIPTION

The I<Helix::Driver::Exceptions> package creates driver exceptions that are used
by all types of drivers.

=head1 EXCEPTIONS

=head2 HXError::Driver

Base driver exception. All other driver exceptions subclass it.

=head1 SEE ALSO

L<Helix>, L<Helix::Core::Exception>,
L<Helix::Core::Exception::Builder>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
