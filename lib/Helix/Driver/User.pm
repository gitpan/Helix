package Helix::Driver::User;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7 
#   ---
#   Helix/Driver/User.pm - generic user driver
#
# ==============================================================================

use base qw/Helix::Driver Class::Accessor::Fast/;
use Helix::Driver::User::Exceptions;
use warnings;
use strict;

__PACKAGE__->mk_accessors(qw/agent ip language referer/);

our $VERSION  = "0.02"; # 2009-05-14 05:33:34

# ------------------------------------------------------------------------------
# \% new()
# constructor
# ------------------------------------------------------------------------------
sub new
{
    my ($class, $self);

    $class = shift;

    # class attributes
    $self  = 
    {
        "ip"       => undef,
        "agent"    => undef,
        "language" => undef,
        "referer"  => undef
    };

    bless $self, $class;
    $self->_init;

    return $self;
}

# ------------------------------------------------------------------------------
# _init()
# class initialization
# ------------------------------------------------------------------------------
sub _init()
{
    my ($self, $buffer);

    $self = shift;

    $self->agent  ( $ENV{"HTTP_USER_AGENT"}      ) if ($ENV{"HTTP_USER_AGENT"});
    $self->referer( $ENV{"HTTP_REFERER"}         ) if ($ENV{"HTTP_REFERER"});
    $self->ip     ( $ENV{"REMOTE_ADDR"}          ) if ($ENV{"REMOTE_ADDR"});
    $self->ip     ( $ENV{"HTTP_X_FORWARDED_FOR"} ) if ($ENV{"HTTP_X_FORWARDED_FOR"});

    if ($ENV{"HTTP_ACCEPT_LANGUAGE"}) 
    {
        ($buffer) = $ENV{"HTTP_ACCEPT_LANGUAGE"} =~ /^([^;]+);/;
        $self->language( substr($buffer, 0, index($buffer, ",")) ) if ($buffer && index($buffer, ",") != -1);
    }
}

# ------------------------------------------------------------------------------
# authorize($login)
# authorize user
# ------------------------------------------------------------------------------
sub authorize
{
    throw HXError::Core::AbstractMethod;
}

# ------------------------------------------------------------------------------
# unauthorize()
# unauthorize user
# ------------------------------------------------------------------------------
sub unauthorize
{
    throw HXError::Core::AbstractMethod;
}

# ------------------------------------------------------------------------------
# $ authorized()
# check if user is authorized
# ------------------------------------------------------------------------------
sub authorized
{
    throw HXError::Core::AbstractMethod;
}

1;

__END__

=head1 NAME

Helix::Driver::User - Helix Framework generic user driver.

=head1 SYNOPSIS

Example user driver:

    package MyApp::Driver::User;
    use base qw/Helix::Driver::User/;

    sub authorized
    {
        my $self = shift;
        throw HXError::Driver::User("This is just an example!");
    }

=head1 DESCRIPTION

The I<Helix::Driver::User> is a generic user driver for 
I<Helix Framework>. It declares some functions that are common for all driver 
types and some abstract methods, that I<must> be overloaded in ancestor classes.
All user drivers should subclass this package.

=head1 METHODS

Private methods are prefixed with I<_> symbol and placed in the end of the list.

=head2 new()

Class constructor. Creates the driver object and calls object initialization 
function.

=head2 authorize($login)

Authorize user. Abstract method, should be overloaded in ancestor class.

=head2 unauthorize()

Unauthorize user. Abstract method, should be overloaded in ancestor class.

=head2 authorized()

Checks if user is authorized. Abstract method, should be overloaded in ancestor
class.

=head2 _init()

Class initialization. Reads environment variables to determine user related 
information.

=head1 ATTRIBUTES

The I<Helix::Driver::User> package has got several useful class 
attributes that filled in during object initialization. These variables could be
accessed through driver object using hashref or subroutine syntax:

    my ($r, $user, $ip, $referer);

    $r       = Helix::Core::Registry->get_instance;
    $user    = $r->loader->get_object("Helix::Driver::User");

    $ip      = $user->ip;       # or $user->{"ip"}
    $referer = $user->referer;  # or $user->{"referer"}

=head2 agent

User's HTTP user agent string (I<User-Agent:> field in HTTP request header).

=head2 ip

User's remote IP address (in string format).

=head2 language

User's preferred language string, that is transferred in HTTP request header
in I<Accept-Languages:> field. If this field contains more than one language,
first is used.

=head2 referer

User's HTTP referer (I<Referer:> field in HTTP request header).

=head1 SEE ALSO

L<Helix>, 
L<Helix::Driver::User::Exceptions>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
