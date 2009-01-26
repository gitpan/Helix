package Helix::Core::Driver::Loader;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Driver/Loader.pm - driver loader
#
# ==============================================================================

use Helix::Driver::Exceptions;
use Helix::Core::Driver::Types;
use warnings;
use strict;

our $VERSION  = "0.01"; # 2008-11-02 21:17:16

# ------------------------------------------------------------------------------
# \% new()
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $self);

    $class = shift;

    # class attributes
    $self  = { "type_cache" => {} };

    bless $self, $class;
    $self->_init();
    
    return $self;
}

# ------------------------------------------------------------------------------
# _init()
# class initialization
# ------------------------------------------------------------------------------
sub _init
{
    my ($self, $r, $drv, $class, $points, $point);

    $self = shift;
    $r    = Helix::Core::Registry->get_instance;
    $drv  = $r->{"cfg"}->{"drivers"};
    
    # loading drivers
    foreach (@$drv) 
    {
        $class  = $_->{"class"};
        $points = exists $_->{"points"} ? $_->{"points"} : undef;

        eval "require $class";
        throw Error::Core::Compile($class) if ($@);
        
        throw Error::Core::Driver::NoType($class)        if (!$class->can("DRIVER_TYPE"));
        throw Error::Core::Driver::AlreadyLoaded($class) if (exists $self->{"type_cache"}->{$class->DRIVER_TYPE});

        $self->{"type_cache"}->{$class->DRIVER_TYPE} = $_;

        # mount objects to global registry
        if ($points) 
        {
            foreach $point (@$points) 
            {
                throw Error::Core::Driver::AlreadyMounted($point) if (exists $self->{$point});
                $self->{$point} = $class->new(@{ $_->{"params"} });
            }
        }
    }
}

# ------------------------------------------------------------------------------
# \% get_config($type)
# get driver configuration
# ------------------------------------------------------------------------------
sub get_config
{
    my ($self, $type) = @_;

    # find driver by subtype
    return $self->{"type_cache"}->{$type} if ($type % 0x100);

    # find driver by type
    foreach (keys %{ $self->{"type_cache"} }) 
    {
        return $self->{"type_cache"}->{$_} if ($type & $_);
    }

    return undef;
}

# ------------------------------------------------------------------------------
# $ is_loaded($type)
# check if driver is loaded
# ------------------------------------------------------------------------------
sub is_loaded
{
    my ($self, $type, $driver);

    ($self, $type) = @_;
    $driver        = $self->get_config($type);

    return $driver ? scalar @{ $driver->{"points"} } : 0;
}

# ------------------------------------------------------------------------------
# \@ get_mount_points($type)
# get driver's mount points
# ------------------------------------------------------------------------------
sub get_mount_points
{
    my ($self, $type, $driver);

    ($self, $type) = @_;
    $driver        = $self->get_config($type);

    return $driver ? $driver->{"points"} : [];
}

# ------------------------------------------------------------------------------
# $ get_class($type)
# get driver's class
# ------------------------------------------------------------------------------
sub get_class
{
    my ($self, $type, $driver);

    ($self, $type) = @_;
    $driver        = $self->get_config($type);

    return $driver ? $driver->{"class"} : undef;
}

# ------------------------------------------------------------------------------
# \@ get_params($type)
# get driver parameters
# ------------------------------------------------------------------------------
sub get_params
{
    my ($self, $type, $driver);

    ($self, $type) = @_;
    $driver        = $self->get_config($type);

    return $driver ? $driver->{"params"} : [];
}

# ------------------------------------------------------------------------------
# \% get_object($type)
# get driver's object
# ------------------------------------------------------------------------------
sub get_object
{
    my ($self, $type, $points);

    ($self, $type) = @_;

    if ($self->is_loaded($type)) 
    {
        $points = $self->get_mount_points($type);
        return $self->{ $points->[0] };
    }

    return undef;
}

1;

__END__

=head1 NAME

Helix::Core::Driver::Loader - Helix Framework driver loader.

=head1 SYNOPSIS

This code must be placed in one of your application's controllers. For example,
in C<lib/Example/Controller/Default.pm>:

    use Helix::Core::Driver::Types;

    sub default : Default
    {
        my $r = Helix::Core::Registry->get_instance;

        if ($r->{"driver"}->is_loaded(DT_TEMPLATE)) 
        {
            $tpl = $r->{"driver"}->get_object(DT_TEMPLATE);
        }
    }

=head1 DESCRIPTION

The I<Helix::Core::Driver::Loader> class parses application configuration's
drivers section and loads some of them. Driver is loaded if it's at least one
mount point defined for it in application configuration. Also, this package
provides methods to access loaded drivers and to check if driver is loaded.

The driver being loaded must contain C<DRIVER_TYPE> constant defined to pass
loader's validity check. To view all available driver types please refer to
L<Helix::Core::Driver::Types>.

The object of I<Helix::Core::Driver::Loader> is mounted in application registry
as C<$r-E<gt>{"driver"}>, so it can be used by any application component. 

=head1 METHODS

=head2 new()

Class constructor. Creates an object and calls the initialization function.

=head2 _init()

Class initialization. Parses I<drivers> section from application configuration 
and loads specified drivers. Each defined driver is included and checked for 
consistency, exception thrown if any error occurs.

=head2 get_config($type)

Returns the driver configuration hashref (that was defined in application 
configuration). C<$type> - type of the desired driver, all driver types are 
listed in L<Helix::Core::Driver::Types>.

=head2 is_loaded($type)

Checks if a driver of the given C<$type> is loaded (i.e. has at least one mount
point in configuration). Returns the number of mount points specified in the 
application configuration for this driver.

=head2 get_mount_points($type)

Returns a reference to the array of mount points specified in the application
configuration for the driver of the given C<$type>.

=head2 get_class($type)

Returns the class name of a driver of the given C<$type>.

=head2 get_params($type)

Returns a reference to the array of driver's initialization parameters, that
were defined in application configuration.

=head2 get_object($type)

Returns an object of the loaded driver. If driver with given C<$type> isn't
loaded C<undef> will be returned.

=head1 SEE ALSO

L<Helix>,
L<Helix::Core::Config>,
L<Helix::Core::Driver::Types>,
L<Helix::Core::Exception::List>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
