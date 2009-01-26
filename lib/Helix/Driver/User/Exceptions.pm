package Helix::Driver::User::Exceptions;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/User/Exceptions.pm - user driver exceptions
#
# ==============================================================================

our $VERSION = "0.01"; # 2009-01-25 17:41:49

use Helix::Core::Exception::Builder 
(
    "Error::Driver::User" => 
    {
        "isa"   => "Error::Driver",
        "title" => "User driver exceptions"
    }
);

1;

__END__

=head1 NAME

Helix::Driver::User::Exceptions - Helix Framework user driver exceptions.

=head1 SYNOPSIS

In error handler of your application (C<lib/Example/Controller/_Error.pm>) you
could write:

    if ($e == Error::Driver::User)
    {
        print "User driver failed!";
    }
    else
    {
        $e->rethrow();
    }

=head1 DESCRIPTION

The I<Helix::Driver::User::Exceptions> package creates user driver 
exceptions that are used by all user drivers.

=head1 EXCEPTIONS

=head2 Error::Driver::User

Base user driver exception. All other user driver exceptions subclass it.

=head1 SEE ALSO

L<Helix>, L<Helix::Driver::Exceptions>,
L<Helix::Core::Exception>,
L<Helix::Core::Exception::Builder>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut