package Helix::Driver::DB::Exceptions;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/DB/Exceptions.pm - database driver exceptions
#
# ==============================================================================

our $VERSION = "0.01"; # 2009-01-25 17:40:15

use Helix::Core::Exception::Builder 
(
    "Error::Driver::DB" => 
    {
        "isa"   => "Error::Driver",
        "title" => "Database driver error"
    },

    "Error::Driver::DB::Connect" => 
    {
        "isa"   => "Error::Driver::DB",
        "title" => "Database connect error"
    },

    "Error::Driver::DB::SQL" => 
    {
        "isa"   => "Error::Driver::DB",
        "title" => "SQL query error"
    }
);

1;

__END__

=head1 NAME

Helix::Driver::DB::Exceptions - Helix Framework database driver exceptions.

=head1 SYNOPSIS

In error handler of your application (C<lib/Example/Controller/_Error.pm>) you
could write:

    if ($e == Error::Driver::DB::SQL)
    {
        print "You have an error in your SQL syntax!";
    }
    else
    {
        $e->rethrow();
    }

=head1 DESCRIPTION

The I<Helix::Driver::DB::Exceptions> package creates database driver exceptions
that are used by all database drivers.

=head1 EXCEPTIONS

=head2 Error::Driver::DB

Base database driver exception. All other database driver exceptions subclass 
it.

=head2 Error::Driver::DB::Connect

Database connection error. Thrown when driver cannot connect or login to 
database engine.

=head2 Error::Driver::DB::SQL

Database SQL execution error. Thrown in case of invalid SQL command.

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

