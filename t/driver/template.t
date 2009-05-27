#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/driver/template.t - generic template driver tests
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
    use_ok("Helix::Driver::Template");
}

# methods
ok( Helix::Driver::Template->can("set"),    "set method"    );
ok( Helix::Driver::Template->can("parse"),  "parse method"  );
ok( Helix::Driver::Template->can("render"), "render method" );

