#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/helix.t - root package tests
#
# ==============================================================================  

use Test::More tests => 2;
use warnings;
use strict;

BEGIN
{
    use_ok("Helix");
}

ok( $Helix::VERSION, "version check" );

