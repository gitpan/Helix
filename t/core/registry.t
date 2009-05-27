#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/core/registry.t - registry tests
#
# ==============================================================================  

use Test::More tests => 6;
use warnings;
use strict;

# ------------------------------------------------------------------------------
# BEGIN()
# test initialization
# ------------------------------------------------------------------------------
BEGIN
{
    use_ok("Helix::Core::Registry");
}

# methods
ok( Helix::Core::Registry->can("get_instance"), "get_instance method" );
ok( Helix::Core::Registry->can("free"),         "free method"         );

# accessors
ok( Helix::Core::Registry->can("cgi"),          "cgi accessor"        );
ok( Helix::Core::Registry->can("config"),       "config accessor"     );
ok( Helix::Core::Registry->can("loader"),       "loader accessor"     );
