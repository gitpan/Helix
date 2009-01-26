package Helix::Driver::Exceptions;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/Exceptions.pm - driver exceptions
#
# ==============================================================================

our $VERSION = "0.01"; # 2009-01-25 17:39:59

use Helix::Core::Exception::Builder 
(
    "Error::Driver" => 
    {
        "isa"   => "Error",
        "title" => "Driver error"
    },

);

1;

__END__

=head1 NAME

Helix::Driver::Exceptions - Helix Framework driver exceptions.

=head1 SYNOPSIS

In error handler of your application (C<lib/Example/Controller/_Error.pm>) you
could write:

    if ($e == Error::Driver)
    {
        print "Driver error occured!";
    }
    else
    {
        $e->rethrow();
    }

=head1 DESCRIPTION

The I<Helix::Driver::Exceptions> package creates driver exceptions that are
used by all types of drivers.

=head1 EXCEPTIONS

=head2 Error::Driver

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
