package Helix::Driver::Log::Generic;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/Log/Generic.pm - generic log driver
#   
# ==============================================================================

use Helix::Core::Driver::Types;
use Helix::Driver::Log::Exceptions;
use POSIX "strftime";
use Fcntl ":flock";
use warnings;
use strict;

our $VERSION = "0.1"; # 2008-10-23 00:00:51

# driver type
use constant DRIVER_TYPE => DT_LOG;

# ------------------------------------------------------------------------------
# \% new($logs_dir, $file)
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $logs_dir, $file, $self);

    ($class, $logs_dir, $file) = @_;

    # class attributes
    $self = 
    { 
        "logs_dir" => $logs_dir,
        "file"     => $file || "system.log",
        "handle"   => undef
    };

    bless $self, $class;

    # check if log directory exists
    throw Error::Driver::Log::Directory($self->{"logs_dir"}) if (!-d $self->{"logs_dir"});

    return $self;
}

# ------------------------------------------------------------------------------
# open()
# open log
# ------------------------------------------------------------------------------
sub open
{
    my $self = shift;

    $self->close if ($self->{"handle"}); 
    open $self->{"handle"}, ">>$self->{'logs_dir'}$self->{'file'}" or 
        throw Error::Driver::Log::Open($self->{"logs_dir"}.$self->{"file"});

    flock $self->{"handle"}, LOCK_EX;
}

# ------------------------------------------------------------------------------
# close()
# close log
# ------------------------------------------------------------------------------
sub close
{
    my $self = shift;

    if ($self->{"handle"}) 
    {
        flock $self->{"handle"}, LOCK_UN;
        close $self->{"handle"};
    }
}

# ------------------------------------------------------------------------------
# notice($msg)
# log notice
# ------------------------------------------------------------------------------
sub notice
{
    throw Error::Core::AbstractMethod;
}

# ------------------------------------------------------------------------------
# warning($msg)
# log warning
# ------------------------------------------------------------------------------
sub warning
{
    throw Error::Core::AbstractMethod;
}

# ------------------------------------------------------------------------------
# error($msg)
# log error
# ------------------------------------------------------------------------------
sub error
{
    throw Error::Core::AbstractMethod;
}

1;

__END__

=head1 NAME

Helix::Driver::Log::Generic - Helix Framework generic log driver.

=head1 SYNOPSIS

Example log driver:

    package Helix::Driver::Log::Example;
    use base qw/Helix::Driver::Log::Generic/;

    use constant DRIVER_TYPE => DT_LOG_EXAMPLE;

    sub notice
    {
        my ($self, $msg) = @_;
        throw Error::Driver::Log::Open("This is just an example!");
    }

    sub warning
    {
        my ($self, $msg) = @_;
        throw Error::Driver::Log::Open("This is just an example!");
    }

    sub error
    {
        my ($self, $msg) = @_;
        throw Error::Driver::Log::Open("This is just an example!");
    }

=head1 DESCRIPTION

The I<Helix::Driver::Log::Generic> is a generic log driver for 
I<Helix Framework>. It declares some functions that are common for all driver 
types and some abstract methods, that I<must> be overloaded in ancestor classes.
All log drivers should subclass this package.

Driver type: C<DT_LOG>.

=head1 METHODS

=head2 new($logs_dir, $file)

Class constructor. Sets initial class data: C<$logs_dir> - directory where log
file will be placed, C<$file> - log file name. Also, this method checks if
C<$log_dir> directory exists, and if it doesn't - throws an exception.

=head2 open()

Opens log file for writing and locks this file in exclusive mode.

=head2 close()

Closes log file.

=head2 notice($msg)

Log a notice message C<$msg>. Abstract method, should be overloaded in ancestor
class.

=head2 warning($msg)

Log a warning message C<$msg>. Abstract method, should be overloaded in ancestor
class.

=head2 error($msg)

Log an error message C<$msg>. Abstract method, should be overloaded in ancestor
class.

=head1 SEE ALSO

L<Helix>, L<Helix::Driver::Log::Exceptions>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
