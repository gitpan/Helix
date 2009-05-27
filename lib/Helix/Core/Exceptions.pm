package Helix::Core::Exceptions;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Exceptions.pm - core exception list
#
# ==============================================================================

use warnings;
use strict;

our $VERSION = "0.02"; # 2009-05-14 04:42:05

use Helix::Core::Exception::Builder
(
    "HXError" =>
    {
        "title" => "Helix error"
    },

    "HXError::Core" => 
    {
        "isa"   => "HXError",
        "title" => "Core error"
    },

    "HXError::Core::Compile" => 
    {
        "isa"   => "HXError::Core",
        "title" => "Compile error"
    },

    "HXError::Core::AbstractMethod" => 
    {
        "isa"   => "HXError::Core",
        "title" => "Abstract method called"
    },

    "HXError::Core::NoRouter" =>
    {
        "isa"   => "HXError::Core",
        "title" => "Router not found, cannot proceed the request"
    },

    "HXError::Core::NoErrorHandler" =>
    {
        "isa"   => "HXError::Core",
        "title" => "No error handler defined for the application"
    },

    "HXError::Core::Loader" => 
    {
        "isa"   => "HXError::Core",
        "title" => "Driver loader error"
    }, 

    "HXError::Core::Loader::InvalidDriver" => 
    {
        "isa"   => "HXError::Core::Loader",
        "title" => "Invalid driver type"
    },

    "HXError::Core::Loader::AlreadyLoaded" => 
    {
        "isa"   => "HXError::Core::Loader",
        "title" => "This type of driver is already loaded"
    },

    "HXError::Core::CGI" => 
    {
        "isa"   => "HXError::Core",
        "title" => "CGI error"
    },

    "HXError::Core::CGI::MaxPost" => 
    {
        "isa"   => "HXError::Core::CGI",
        "title" => "Too big POST request"
    },

    "HXError::Core::CGI::InvalidPOST" => 
    {
        "isa"   => "HXError::Core::CGI",
        "title" => "Invalid POST request"
    },

    "HXError::Core::CGI::FileSave" => 
    {
        "isa"   => "HXError::Core::CGI",
        "title" => "HXError saving file"
    }
);

1;

__END__

=head1 NAME

Helix::Core::Exceptions - Helix Framework core exception list.

=head1 SYNOPSIS

In error handler of your application (C<lib/Example/Error.pm>) you
could write:

    if ($e eq "HXError::Core::AbstractMethod")
    {
        print "Abstract method called";
    }
    elsif ($e eq "HXError::Core::CGI::InvalidPOST")
    {
        print "Malformed POST request";
    }

=head1 DESCRIPTION

The I<Helix::Core::Exceptions> package creates core exceptions that are used by
various core packages.

=head1 EXCEPTIONS

=head2 HXError

Base I<Helix Framework> exception. All other exceptions subclass it.

=head2 HXError::Core

Base core exception. All other core exceptions subclass it.

=head2 HXError::Core::Compile

Compilation error. Thrown when driver or controller raised perl compile error
during require or use.

=head2 HXError::Core::AbstractMethod

Abstract method error. Thrown when abstract method is called.

=head2 HXError::Core::NoRouter

No router defined. Raised when application has no router driver defined in the
application configuration file.

=head2 HXError::Core::NoErrorHandler

No error handler defined. Raised when there is no error handler defined in the
application configuration.

=head2 HXError::Core::Loader

Driver loader exceptions. All other driver loader exceptions subclass it.

=head2 HXError::Core::Loader::InvalidDriver

Thrown when driver being loaded isn't subclassed from L<Helix::Driver> class.

=head2 HXError::Core::Loader::AlreadyLoaded

Thrown when driver of the given type is already loaded.

=head2 HXError::Core::CGI

CGI error. All other CGI errors subclass this exception.

=head2 HXError::Core::CGI::MaxPost

POST request size limit exceeded.

=head2 HXError::Core::CGI::InvalidPOST

Malformed POST request.

=head2 HXError::Core::CGI::FileSave

Error saving uploaded file (during I<multipart/form-data> form submission).

=head1 SEE ALSO

L<Helix>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
