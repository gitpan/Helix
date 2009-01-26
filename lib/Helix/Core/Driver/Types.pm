package Helix::Core::Driver::Types;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/Driver/Types.pm - driver types
#
# ==============================================================================

use Exporter qw/import/;
use warnings;
use strict;

our (@EXPORT, $VERSION);

$VERSION = "0.01"; # 2008-11-04 01:53:19 
@EXPORT  = qw/DT_DATABASE 
              DT_DATABASE_POSTGRESQL
              DT_LOG      
              DT_LOG_SIMPLE 
              DT_TEMPLATE 
              DT_TEMPLATE_HTML 
              DT_USER     
              DT_USER_SIMPLE/;

# driver types
use constant 
{
    # database drivers
    "DT_DATABASE"            => 0x0100,
    "DT_DATABASE_POSTGRESQL" => 0x0101,

    # log drivers
    "DT_LOG"                 => 0x0200,
    "DT_LOG_SIMPLE"          => 0x0201,

    # template drivers
    "DT_TEMPLATE"            => 0x0400,
    "DT_TEMPLATE_HTML"       => 0x0401,

    # user drivers
    "DT_USER"                => 0x0800,
    "DT_USER_SIMPLE"         => 0x0801
};

1;

__END__

=head1 NAME

Helix::Core::Driver::Types - Helix Framework driver types.

=head1 SYNOPSIS

    use Helix::Core::Driver::Types;

=head1 DESCRIPTION

The I<Helix::Core::Driver::Types> package contains constant definitions for all
driver types, that are exist in I<Helix Framework>. These constants are 
automatically exported when this package is used.

=head1 CONSTANTS

=head2 DT_DATABASE

Generic database driver type. Every database driver will match this driver type
too.

=head2 DT_DATABASE_POSTGRESQL

PostgreSQL database driver type.

=head2 DT_LOG

Generic log driver type. Every log driver will match this driver type too.

=head2 DT_LOG_SIMIPLE

Simple log driver type.

=head2 DT_TEMPLATE

Generic template engine driver type. Every template driver will match this
driver type too.

=head2 DT_TEMPLATE_HTML

HTML::Template driver type.

=head2 DT_USER

Generic user driver type. Every user driver will match this driver type too.

=head2 DT_USER_SIMPLE

Simple user driver type.

=head1 SEE ALSO

L<Helix>,
L<Helix::Core::Driver::Loader>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
