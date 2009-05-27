#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/driver/user.t - generic user driver tests
#
# ==============================================================================  

use Test::More tests => 5;
use warnings;
use strict;

# ------------------------------------------------------------------------------
# BEGIN()
# test initialization
# ------------------------------------------------------------------------------
BEGIN
{
    use_ok("Helix::Driver::Exceptions");
    use_ok("Helix::Driver::User");
}

# methods
ok( Helix::Driver::User->can("authorize"),   "authorize method"   );
ok( Helix::Driver::User->can("unauthorize"), "unauthorize method" );
ok( Helix::Driver::User->can("authorized"),  "authorized method"  );

