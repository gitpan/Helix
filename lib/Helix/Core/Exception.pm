package Helix::Core::Exception;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Exception.pm - base exception class
#
# ==============================================================================

use warnings;
use strict;

our $VERSION = "0.01"; # 2009-01-25 17:38:39

use constant TITLE => "Base exception";

# overload some operations
use overload
    "bool" => sub { 1 },
    "eq"   => "overloaded_equ",
    '""'   => "overloaded_str";

# ------------------------------------------------------------------------------
# \% new($message)
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $message, $self);

    ($class, $message) = @_;

    # class attributes
    $self = 
    {
        "message" => $message,
        "line"    => undef,
        "file"    => undef
    };

    bless $self, $class;
    $self->_init;

    return $self;
}

# ------------------------------------------------------------------------------
# _init()
# class initialization
# ------------------------------------------------------------------------------
sub _init
{
    my ($self, $file, $line);

    $self = shift;

    # get caller info
    (undef, $file, $line) = caller(2);
    $self->{"file"} = $file;
    $self->{"line"} = $line;
}

# ------------------------------------------------------------------------------
# throw()
# throw exception
# ------------------------------------------------------------------------------
sub throw
{
    my $class = shift;

    $class->rethrow(@_) if (ref $class);
    die $class->new(@_);
}

# ------------------------------------------------------------------------------
# rethrow()
# rethrow exception
# ------------------------------------------------------------------------------
sub rethrow
{
    die $_[0] if (ref $_[0]);
}

# ------------------------------------------------------------------------------
# $ overloaded_equ($class)
# check the type of exception
# ------------------------------------------------------------------------------
sub overloaded_equ
{
    return $_[0]->isa($_[1]);
}

# ------------------------------------------------------------------------------
# $ overloaded_str()
# stringify exception
# ------------------------------------------------------------------------------
sub overloaded_str
{
    my ($self, $str);

    $self = shift;
    $str  = $self->TITLE;
    $str .= $self->{"message"} ? ": $self->{message}" : "";

    return $str;
}

1;

__END__

=head1 NAME

Helix::Core::Exception - base exception class for Helix Framework.

=head1 SYNOPSIS

General exception usage example:

    eval
    {
        # ...
        
        throw Error::Core::Router::NotFound("Oops!");

        # ...
    };

    if ($@)
    {
        my $e = $@;

        if ($e == "Error::Core::Router::NotFound")
        {
            print $e; # prints "Oops!"
        }
        else
        {
            $e->rethrow;
        }
    }

=head1 DESCRIPTION

The I<Helix::Core::Exception> class is a base class for all core, driver and 
application exceptions. It contains various methods that can be useful for 
exception handling. This package is a rework of CPAN
L<Exception> package.

=head1 METHODS

=head2 new($message)

Class constructor. Creates an exception object and calls class initialization
function. Don't raise exceptions using this method, use C<throw()> instead.

=head2 _init()

Exception initializaton. Tracks file name and line where exception occured.

=head2 throw()

Throws exception. Actually, creates an I<Helix::Core::Exception> object and 
dies.

=head2 rethrow()

Rethrows the exception (if it was thrown before).

=head2 overloaded_equ($class)

Overloaded equality comparsion operator (==). Checks if exception is the
instance of C<$class> specified.

=head2 overloaded_str()

Overloaded stringify operation. Returns exception message.

=head1 SEE ALSO

L<Helix>, 
L<Helix::Core::Exception::Builder>,
L<Helix::Core::Exception::List>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
