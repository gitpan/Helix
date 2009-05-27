package Helix::Driver::Router;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/Router.pm - router generic driver
#
# ==============================================================================

use base qw/Helix::Driver/;
use Helix::Driver::Router::Exceptions;
use warnings;
use strict;

our $VERSION  = "0.02"; # 2009-05-14 05:25:08

# ------------------------------------------------------------------------------
# \% new()
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $self);

    $class = shift;
    $self  = 
    {
        "controller" => undef,  # relative path to controller
        "handler"    => undef,  # handler reference
        "params"     => undef   # handler params
    };

    bless $self, $class;

    return $self;
}

# ------------------------------------------------------------------------------
# find_handler()
# find a query handler
# ------------------------------------------------------------------------------
sub find_handler
{
    throw HXError::Core::AbstractMethod;
}

# ------------------------------------------------------------------------------
# get_handler()
# get handler reference
# ------------------------------------------------------------------------------
sub get_handler
{
    return $_[0]->{"handler"};
}

# ------------------------------------------------------------------------------
# get_params()
# get handler params
# ------------------------------------------------------------------------------
sub get_params
{
    return $_[0]->{"params"};
}

1;

__END__

=head1 NAME

Helix::Driver::Router - Helix Framework generic router driver.

=head1 SYNOPSIS

Example router driver:

    package MyApp::Driver::Router;
    use base qw/Helix::Driver::Router/;

    sub find_handler
    {
        my $self = shift;

        # ...

        if (!$handler_found)
            throw HXError::Driver::Router::NotFound;
        
        $self->{"handler"} = ...;
        $self->{"params"}  = ...;
    }

=head1 DESCRIPTION

The I<Helix::Driver::Router> is a generic router driver for I<Helix Framework>.
It declares some basic functions that are common for all driver types and one 
abstract method, that I<must> be overloaded in ancestor classes. All router 
drivers should subclass this package.

=head1 METHODS

=head2 new()

Class constructor. 

=head2 find_handler()

Finds a query handler. Abstract method, should be overloaded by the ancestor class.

=head2 get_handler()

Returns a reference to the query handler subroutine.

=head2 get_params()

Returns a reference to the array of query handler parameters.

=head1 SEE ALSO

L<Helix>, L<Helix::Application>, L<Helix::Driver::Router::Exceptions>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut

