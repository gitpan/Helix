package Helix::Driver::Log::Exceptions;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/Log/Exceptions.pm - log driver exceptions
#
# ==============================================================================

use warnings;
use strict;

our $VERSION = "0.02"; # 2009-05-14 05:44:28

use Helix::Core::Exception::Builder 
(
    "HXError::Driver::Log" => 
    {
        "isa"   => "HXError::Driver",
        "title" => "Log driver error"
    },

    "HXError::Driver::Log::Directory" => 
    {
        "isa"   => "HXError::Driver::Log",
        "title" => "Cannot open log directory"
    },

    "HXError::Driver::Log::Open" => 
    {
        "isa"   => "HXError::Driver::Log",
        "title" => "Cannot open log file"
    }
);

1;

__END__

=head1 NAME

Helix::Driver::Log::Exceptions - Helix Framework log driver exceptions.

=head1 SYNOPSIS

In error handler of your application (C<lib/Example/Error.pm>) you could write:

    if ($e eq "Error::Driver::Log::Open")
    {
        print "Cannot open log file!";
    }
    else
    {
        $e->rethrow();
    }

=head1 DESCRIPTION

The I<Helix::Driver::Log::Exceptions> package creates log driver exceptions that
are used by all log drivers.

=head1 EXCEPTIONS

=head2 Error::Driver::Log

Base log driver exception. All other log driver exceptions subclass it.

=head2 Error::Driver::Log::Directory

Error opening log directory. Thrown when log directory doesn't exist.

=head2 Error::Driver::Log::Open

Error opening log file. Thrown when driver cannot open log file for writing.

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
