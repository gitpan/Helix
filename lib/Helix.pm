package Helix;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix.pm - root metapackage
#
# ==============================================================================

use 5.008008;
use warnings;
use strict;

our $VERSION = "0.01"; # 2008-11-28 02:18:32

1;

__END__

=head1 NAME

Helix - web application framework.

=head1 DESCRIPTION

The I<Helix Framework> is intended to turn a headache of web user interface 
development into something easy and full of fun. The main goal of the project is
to ease the creation of various web-based backends and systems such as project 
management systems, customer relationship management systems, online payment 
services and so on. You can use this framework for web site creation too, but it
isn't recommended - try to use another powerful tools, that are intended for 
this task (for example, Typo3 CMF, Moveable Type or, say, Wordpress).

=head2 Yet another Perl framework? What for?

There is a lot of another Perl frameworks today - Jifty, Hyper, Konstrukt, Rose,
RWDE, Gantry, Catalyst, POE, BlackFramework, etc. Some of them have too much
dependencies, some take too much time to do easy things, some force you to use
only one way to do something (is it Perl or what?!), some of them are already 
unsupported, some are too complicated and have a confusing API... all of this 
was the cause of the I<Helix Framework> birth.

=head2 Features

=over 4

=item * Small core

There is only 10 core packages that occupy approximately 60 Kb of disc space, 
including POD sections and various comments. It means that anyone can easily 
I<understand> how the core works, which algorithms it uses, what it can do and
what it can't. 

OK, - you'll say - but I<Helix Framework> is only at 0.01 version, its core will
grow in future versions! I should say that it will, but not very much. Actually,
the core does all of tasks it should do now, but in future some tasty features
may be added. Anyway, the core will remain I<understandable> and clear to anyone 
who understands Perl.

=item * Object oriented API

The I<Helix Framework> is almost fully object oriented (except L<Helix::Debug>
module), each class is well-documented in awful English. 

=item * CGI and FastCGI support

I<Helix Framework> applications can work both in CGI and FastCGI mode. For 
FastCGI applications support you need L<FCGI> module to be installed.

=item * A few dependencies

Yes, it is a feature, not a bug. One of Perl frameworks frightened me when I've
been installing it through CPAN shell - I thought it depends on a half of all 
CPAN modules.

=item * TMTOWTDI

There is more than one way to do it. Larry presented this ability to all of us, 
so keeping this principle is the sign of our respect (and logicality).

=item * Code generator

The L<helix> code generator will help you to create the application skeleton, so
you won't need to make applications from scratch.

=back

=head1 NOTES

Please note that I<Helix Framework> core API is subject to change until 0.10
version release. 

=head1 SEE ALSO

L<helix(1)>, L<Helix::Application>

L<http://www.atma7.com/products/helix/> - official project web page.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under 
the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
