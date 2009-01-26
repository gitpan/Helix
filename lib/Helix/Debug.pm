package Helix::Debug;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Debug.pm - debugging facility
#
# ==============================================================================

use warnings;
use strict;

our $VERSION = "0.01"; # 2008-10-17 23:26:38

# ------------------------------------------------------------------------------
# BEGIN()
# package initialization
# ------------------------------------------------------------------------------
BEGIN 
{
    $SIG{"__WARN__"} = \&warn;
    $SIG{"__DIE__"}  = \&die;
}

# ------------------------------------------------------------------------------
# \@ get_stack()
# get call stack
# ------------------------------------------------------------------------------
sub get_stack
{
    my (@stack, $package, $file, $line, $sub, $level);

    # we don't need this function in stack
    $level = 1;

    # walk stack
    while (($package, $file, $line, $sub) = caller($level)) 
    {
        push @stack, 
        {
            "package" => $package,
            "file"    => $file,
            "line"    => $line,
            "sub"     => $sub
        };

        $level++;
    }

    return \@stack;
}

# ------------------------------------------------------------------------------
# print_stack(@$stack)
# print call stack
# ------------------------------------------------------------------------------
sub print_stack
{
    my ($stack, $level, $sublen, $sub);

    $stack = shift;
    $sublen = 0;
  
    print "* Call stack\n* ----------\n";

    # count fields width
    $sublen = length($_->{"sub"}) > $sublen ? length($_->{"sub"}) : $sublen foreach (@$stack);

    # print stack
    foreach (reverse @$stack) 
    {
        print sprintf
        (
            "* %05d %-${sublen}s  %s\n",
            $_->{"line"},
            $sub ? $sub : "main",
            $_->{"file"}
        );

        $sub = $_->{"sub"};
    }
}

# ------------------------------------------------------------------------------
# warn($message)
# warning handler
# ------------------------------------------------------------------------------
sub warn
{
    my ($message, $stack, $phase);

    $message = shift;
    $phase = defined $^S ? "Runtime" : "Compile";

    # print HTTP header
    print "Content-Type: text/html; charset=UTF-8\n\n" if (!tell STDOUT);
    
    print "<pre>";
    print "<b>$phase warning: $message</b>\n";
    print "</pre>";
}

# ------------------------------------------------------------------------------
# die($message)
# die handler
# ------------------------------------------------------------------------------
sub die
{
    my ($message, $stack, $phase);

    $message = shift;
    $phase = defined $^S ? "Runtime" : "Compile";

    # call original die if called from eval block
    CORE::die($message) if (defined $^S && $^S == 1);

    # print HTTP header
    print "Content-Type: text/html; charset=UTF-8\n\n" if (!tell STDOUT);

    print "<pre>";
    print "<b>$phase error: $message</b>\n";

    # don't show stack on compile errors
    if (defined $^S) 
    {
        print_stack(get_stack());
    }

    print "</pre>";

    exit;
}

1;

__END__

=head1 NAME

Helix::Debug - Helix Framework debugging facility.

=head1 SYNOPSIS

In CGI gateway of your application (C<index.cgi>) write:

    use Helix::Debug;

=head1 DESCRIPTION

The I<Helix::Debug> package provides an easy way to avoid a confusing 
I<Internal Server Error> message. It sends HTTP header before displaying 
error, so you don't need to dig web-server's log to find the cause of 
the error anymore. Obviously, it will do nothing if error is in your web-server
configuration, so if I<Internal Server Error> message still remains, check your
web-server's configuration. Also, this package displays a stack trace when 
application dies. It is very useful in application development, so 
I<Helix::Debug> is used in CGI type applications by default.

This package doesn't depend on any other framework package, so you can use it
outside I<Helix Framework> applications too.

While used, I<Helix::Debug> hooks global C<die> and C<warn> subroutines, so be
careful using other packages, that modify or depend on C<$SIG{"__DIE__"}> and
C<$SIG{"__WARN__"}> handlers.

=head1 METHODS

=head2 get_stack()

Get subroutine call stack. Returns reference to array of hashrefs, each hashref
stands for one level of the call stack. This hashref contains the following 
data:

=over 4

=item * package

Package name, where error has been occured.

=item * file

File name, where error has been occured.

=item * line

Line number, which caused program to die.

=item * sub

Subroutine name, where error has been occured.

=back

=head2 print_stack($stack)

Prints the call stack in nice preformatted table. C<$stack> - reference to
array of call stack hashrefs (result, returned by C<get_stack()> subroutine).

=head2 warn($message)

Custom warning handler. C<$message> - warning message to be displayed. Prints
HTTP header before message, so warning message could be shown in web browser.

=head2 die($message)

Custom error handler. C<$message> - error message to be displayed. Prints HTTP
header before message, so error message could be shown in web browser.

=head1 SEE ALSO

L<Helix>, L<Helix::Application>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
