package Helix::Driver::DB::Exceptions;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/DB/Exceptions.pm - database driver exceptions
#
# ==============================================================================

use warnings;
use strict;

our $VERSION = "0.02"; # 2009-05-14 05:36:22

use Helix::Core::Exception::Builder 
(
    "HXError::Driver::DB" => 
    {
        "isa"   => "HXError::Driver",
        "title" => "Database driver error"
    },

    "HXError::Driver::DB::Connect" => 
    {
        "isa"   => "HXError::Driver::DB",
        "title" => "Database connect error"
    },

    "HXError::Driver::DB::SQL" => 
    {
        "isa"   => "HXError::Driver::DB",
        "title" => "SQL query error"
    },

    "HXError::Driver::DB::AlreadyFetched" =>
    {
        "isa"   => "HXError::Driver::DB",
        "title" => "Data is already fetched during query execution (auto_fetch option is on)"
    }
);

1;

__END__

=head1 NAME

Helix::Driver::DB::Exceptions - Helix Framework database driver exceptions.

=head1 SYNOPSIS

In error handler of your application (C<lib/Example/Error.pm>) you could write:

    if ($e eq "HXError::Driver::DB::SQL")
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

