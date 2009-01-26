package Helix::Core::Exception::List;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Exception/List.pm - core exception list
#
# ==============================================================================

our $VERSION = "0.01"; # 2009-01-25 17:36:17

use Helix::Core::Exception::Builder
(
    "Error" => 
    {
        "title" => "Error"
    },

    "Error::Core" => 
    {
        "isa"   => "Error",
        "title" => "Core error"
    },

    "Error::Core::Compile" => 
    {
        "isa"   => "Error::Core",
        "title" => "Compile error"
    },

    "Error::Core::AbstractMethod" => 
    {
        "isa"   => "Error::Core",
        "title" => "Abstract method called"
    },

    "Error::Core::DoubleFault" => 
    {
        "isa"   => "Error::Core",
        "title" => "Double fault"
    },

    "Error::Core::Driver" => 
    {
        "isa"   => "Error::Core",
        "title" => "Driver error"
    }, 

    "Error::Core::Driver::NoType" => 
    {
        "isa"   => "Error::Core::Driver",
        "title" => "No driver type declaration"
    },

    "Error::Core::Driver::AlreadyLoaded" => 
    {
        "isa"   => "Error::Core::Driver",
        "title" => "This type of driver is already loaded"
    },

    "Error::Core::Driver::AlreadyMounted" => 
    {
        "isa"   => "Error::Core::Driver",
        "title" => "This mount point is already occupied by another driver"
    },

    "Error::Core::CGI" => 
    {
        "isa"   => "Error::Core",
        "title" => "CGI error"
    },

    "Error::Core::CGI::MaxPost" => 
    {
        "isa"   => "Error::Core::CGI",
        "title" => "Too big POST request"
    },

    "Error::Core::CGI::InvalidPOST" => 
    {
        "isa"   => "Error::Core::CGI",
        "title" => "Invalid POST request"
    },

    "Error::Core::CGI::FileSave" => 
    {
        "isa"   => "Error::Core::CGI",
        "title" => "Error saving file"
    },

    "Error::Core::CGI::NoSession" =>
    {
        "isa"   => "Error::Core::CGI",
        "title" => "Session does not exist"
    },

    "Error::Core::Router" => 
    {
        "isa"   => "Error::Core",
        "title" => "Routing error"
    },

    "Error::Core::Router::NotFound" => 
    {
        "isa"   => "Error::Core::Router",
        "title" => "Page not found"
    },

    "Error::Core::Router::Forbidden" => 
    {
        "isa"   => "Error::Core::Router",
        "title" => "Authorization required"
    },
);

1;

__END__

=head1 NAME

Helix::Core::Exception::List - Helix Framework core exceptions.

=head1 SYNOPSIS

In error handler of your application (C<lib/Example/Controller/_Error.pm>) you
could write:

    if ($e == Error::Core::Router::NotFound)
    {
        print "Page not found";
    }
    elsif ($e == Error::Core::Router::Forbidden)
    {
        print "Achtung! Russisch partizanen!";
    }

=head1 DESCRIPTION

The I<Helix::Core::Exception::List> package creates core exceptions that are
used by various core packages.

=head1 EXCEPTIONS

=head2 Error

Base I<Helix Framework> exception. All other exceptions subclass it.

=head2 Error::Core

Base core exception. All other core exceptions subclass it.

=head2 Error::Core::Compile

Compilation error. Thrown when driver or controller raised perl compile error
during require or use.

=head2 Error::Core::AbstractMethod

Abstract method error. Thrown when abstract method called.

=head2 Error::Core::DoubleFault

Double fault error. Raised when exception was thrown during another exception
handling.

=head2 Error::Core::Driver

Driver loader exceptions. All other driver loaded exceptions subclass it.

=head2 Error::Core::Driver::NoType

Thrown when driver being loaded has no driver type specification.

=head2 Error::Core::Driver::AlreadyLoaded

Thrown when driver of the given type is already loaded.

=head2 Error::Core::Driver::AlreadyMounted

Thrown when driver's mount point is already occupied by another driver.

=head2 Error::Core::CGI

CGI errors. All other CGI errors subclass this exception.

=head2 Error::Core::CGI::MaxPost

POST request size limit exceeded.

=head2 Error::Core::CGI::InvalidPOST

Malformed POST request.

=head2 Error::Core::CGI::FileSave

Error saving uploaded file (during I<multipart/form-data> form submission).

=head2 Error::Core::Router

Request routing error. All other routing exceptions subclass it.

=head2 Error::Core::Router::NotFound

Hanlder (page) was not found.

=head2 Error::Core::Router::Forbidden

Authorization required to view this page.

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
