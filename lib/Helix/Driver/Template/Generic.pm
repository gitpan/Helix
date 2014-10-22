package Helix::Driver::Template::Generic;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/Template/Generic.pm - generic template driver
#
# ==============================================================================

use Helix::Core::Driver::Types;
use Helix::Driver::Template::Exceptions;
use warnings;
use strict;

our $VERSION = "0.01"; # 2008-10-18 23:58:40

# driver type
use constant DRIVER_TYPE => DT_TEMPLATE;

# ------------------------------------------------------------------------------
# \% new()
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $templates_dir, $self);

    ($class, $templates_dir) = @_;

    # class attributes
    $self = 
    { 
        "templates_dir" => $templates_dir || "./templates/",
        "object"        => undef,
        "result"        => undef,
        "vars"          => {}
    };

    bless $self, $class;

    # check if template directory exists
    throw Error::Driver::Template::Directory($self->{"templates_dir"}) if (!-d $self->{"templates_dir"});

    return $self;
}

# ------------------------------------------------------------------------------
# set(%vars)
# set template variables
# ------------------------------------------------------------------------------
sub set
{
    my ($self, %vars) = @_;

    foreach (keys %vars) 
    { 
        undef $self->{"vars"}->{$_} if (exists $self->{"vars"}->{$_});
        $self->{"vars"}->{$_} = $vars{$_};
    }
}

# ------------------------------------------------------------------------------
# parse($tpl)
# parse template
# ------------------------------------------------------------------------------
sub parse
{
    throw Error::Core::AbstractMethod;
}

# ------------------------------------------------------------------------------
# render()
# render template
# ------------------------------------------------------------------------------
sub render
{
    throw Error::Core::AbstractMethod;
}

1;

__END__

=head1 NAME

Helix::Driver::Template::Generic - Helix Framework generic template driver.

=head1 SYNOPSIS

Example template driver:

    package Helix::Driver::Template::Example;
    use base qw/Helix::Driver::Template::Generic/;

    use constant DRIVER_TYPE => DT_TEMPLATE_EXAMPLE;

    sub parse
    {
        my ($self, $tpl) = @_;
        throw Error::Driver::Template::Open("This is just an example!");
    }

    sub render
    {
        my $self = shift;
        throw Error::Driver::Template::Open("This is just an example!");
    }

=head1 DESCRIPTION

The I<Helix::Driver::Template::Generic> is a generic template driver for 
I<Helix Framework>. It declares some functions that are common for all driver 
types and some abstract methods, that I<must> be overloaded in ancestor classes.
All template drivers should subclass this package.

Driver type: C<DT_TEMPLATE>.

=head1 METHODS

=head2 new($templates_dir)

Class constructor. Sets initial class data: C<$templates_dir> - directory where 
template file will be placed, and checks if C<$template_dir> directory exists, 
and if it doesn't - throws an exception.

=head2 set(%vars)

Sets template variables. C<%vars> - hash of variables and corresponding values.
For example:

    (
        "title"   => "Hello, world!",
        "content" => "Blabla"
    )

=head2 parse($tpl)

Parses a C<$tpl> template. Abstract method, should be overloaded in ancestor
class.

=head2 render()

Renders a previously parsed template. Abstract method, should be overloaded in
ancestor class.

=head1 SEE ALSO

L<Helix>, 
L<Helix::Driver::Template::Exceptions>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
