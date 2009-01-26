package Helix::Driver::DB::Generic;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Driver/DB/Generic.pm - generic database driver
#
# ==============================================================================

use Helix::Core::Driver::Types;
use Helix::Driver::DB::Exceptions;
use DBI;
use warnings;
use strict;

our $VERSION = "0.01"; # 2008-11-04 16:22:52

# driver type
use constant DRIVER_TYPE => DT_DATABASE;

# ------------------------------------------------------------------------------
# \% new($dbd, $db, $user, $password, $host, $port, $cfg)
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $dbd, $db, $user, $password, $host, $port, $cfg, $self);

    ($class, $dbd, $db, $user, $password, $host, $port, $cfg) = @_;

    # class attributes
    $self  = 
    {
        # connection settings
        "dbd"         => $dbd,
        "database"    => $db,
        "user"        => $user,
        "password"    => $password,
        "host"        => $host || "localhost",
        "port"        => $port || 5432,

        # other settings
        "auto_fetch"  => $cfg && exists $cfg->{"auto_fetch"}  ? $cfg->{"auto_fetch"}  : 1,
        "auto_commit" => $cfg && exists $cfg->{"auto_commit"} ? $cfg->{"auto_commit"} : 1,

        # handles
        "dbh"         => undef,
        "sth"         => undef,

        # data
        "query"       => undef,
        "query_count" => 0,
        "row_count"   => 0,
        "dataset"     => []
    };

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
    my $self = shift;

    eval 
    {
        $self->{"dbh"} = DBI->connect
        (
            "DBI:$self->{'dbd'}:database=$self->{'database'};host=$self->{'host'};port=$self->{'port'}", 

            $self->{"user"},
            $self->{"password"},

            {
                "RaiseError"      => 1,
                "PrintError"      => 0,
                "PrintWarn"       => 0,
                "InactiveDestroy" => 1,
                "AutoCommit"      => $self->{"auto_commit"}
            }
        );
    }; 

    throw Error::Driver::DB::Connect($@) if ($@);
}

# ------------------------------------------------------------------------------
# \@ execute($query, @params)
# query execution
# ------------------------------------------------------------------------------
sub execute
{
    my ($self, $query, @params, $row);

    ($self, $query, @params) = @_;

    eval 
    { 
        $self->{"query"} = $query;
        $self->{"query_count"}++;
        $self->{"row_count"} = 0;
        $self->free;

        # query execution
        $self->{"sth"} = $self->{"dbh"}->prepare($query);
        $self->{"sth"}->execute(@params);
        $self->fetch_all if ($self->{"auto_fetch"});
    };

    throw Error::Driver::DB::SQL($query) if ($@);

    return $self->{"dataset"} if ($self->{"auto_fetch"});
}

# ------------------------------------------------------------------------------
# \@ execute_prepared(@params)
# execute prepared query
# ------------------------------------------------------------------------------
sub execute_prepared
{
    my ($self, @params, $row);

    ($self, @params) = @_;

    eval
    {
        $self->{"query_count"}++;
        $self->{"dataset"} = [] if ($self->{"dataset"});

        $self->{"sth"}->execute(@params);
        $self->fetch_all if ($self->{"auto_fetch"});
    };

    throw Error::Driver::DB::SQL($self->{"query"}) if ($@);

    return $self->{"dataset"} if ($self->{"auto_fetch"});
}

# ------------------------------------------------------------------------------
# fetch()
# fetch result
# ------------------------------------------------------------------------------
sub fetch
{
    my ($self, $row);
    
    $self = shift;

    $row  = $self->{"sth"}->fetchrow_hashref;
    push @{ $self->{"dataset"} }, $row if ($row); 

    return $row;
}

# ------------------------------------------------------------------------------
# fetch_all()
# fetch all results
# ------------------------------------------------------------------------------
sub fetch_all
{
    my $self = shift;

    while ($self->fetch) {};

    return $self->{"dataset"};
}

# ------------------------------------------------------------------------------
# free()
# free memory
# ------------------------------------------------------------------------------
sub free
{
    my $self = shift;

    $self->{"sth"}->finish  if ($self->{"sth"});

    if ($self->{"dataset"}) 
    {
        undef $self->{"dataset"};
        $self->{"dataset"} = [];
    }
}

# ------------------------------------------------------------------------------
# \@ call($function, @params)
# stored function/procedure call
# ------------------------------------------------------------------------------
sub call
{
    throw Error::Core::AbstractMethod;
}

# ------------------------------------------------------------------------------
# DESTROY()
# destructor
# ------------------------------------------------------------------------------
sub DESTROY
{
    $_[0]->{"dbh"}->disconnect if ($_[0]->{"dbh"});
}

1;

__END__

=head1 NAME

Helix::Driver::DB::Generic - Helix Framework generic database driver.

=head1 SYNOPSIS

Example database driver:

    package Helix::Driver::DB::Example;
    use base qw/Helix::Driver::DB::Generic/;

    use constant DRIVER_TYPE => DT_DATABASE_EXAMPLE; 

    sub new
    {
        my ($class, $self);

        $class = shift;
        $self  = $class->SUPER::new("Example", @_);

        return $self;
    }

    sub call
    {
        my ($self, $function, @params, $query);

        ($self, $function, @params) = @_;
        throw Error::Driver::DB::SQL($function);

        # never will reach here
        return $self->execute($query, @params);
    }

=head1 DESCRIPTION

The I<Helix::Driver::DB::Generic> is a generic database driver for 
I<Helix Framework>. It declares some functions that are common for all driver 
types and some abstract methods, that I<must> be overloaded in ancestor classes.
All database drivers should subclass this package.

Actually, I<Helix Framework> database stack is more high-level abstraction over 
the L<DBI> package. However, this abstraction is not I<ORM>-like but makes SQL
syntax differences between different DBMSs less visible.

To use database drivers you must have L<DBI> and needed L<DBD> packages 
installed.

Driver type: C<DT_DATABASE>.

=head1 METHODS

Private methods are prefixed with I<_> symbol and placed in the end of the list.

=head2 new($dbd, $db, $user, $password, $host, $port, $cfg)

Class constructor. Sets initial class data: C<$dbd> - DBI driver name, C<$db> -
database name, C<$user> - database user name, C<$password> - database password,
C<$host> - database host, C<$port> - database port, C<$cfg> - configuration 
hashref:

=over 4

=item auto_fetch

Automatically fetch all query results right after query execution. Default value
is I<1>.

=item auto_commit

Automatically commit transaction after each SQL query. Default value is I<1>.

=back

=head2 execute($query, @params)

Query execution. Given C<$query> executed with binded C<@params>. If any error
occurs, exception is thrown.

=head2 execute_prepared(@params)

Prepared query execution. Previously executed query will be executed again with
new C<@params>.

=head2 fetch()

Returns one row fetched from database or C<undef> if no results remained.

=head2 fetch_all()

Returns reference to array of all rows fetched from database after query 
execution.

=head2 free()

Clear in-memory cache of fetched data.

=head2 call($function, @params)

Call stored procedure or function with C<$function> as name and C<@params> as
parameters. Abstract method, should be overloaded in ancestors.

=head2 _init()

Class initialization. Performs a connection to database engine.

=head1 SEE ALSO

L<Helix>, L<Helix::Driver::DB::Exceptions>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut

