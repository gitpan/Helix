#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/driver/db.t - generic database driver tests
#
# ==============================================================================  

use Test::More tests => 8;
use warnings;
use strict;

# ------------------------------------------------------------------------------
# BEGIN()
# test initialization
# ------------------------------------------------------------------------------
BEGIN
{
    use_ok("Helix::Driver::Exceptions");
    use_ok("Helix::Driver::DB");
}

# methods
ok( Helix::Driver::DB->can("execute"),          "execute method"          );
ok( Helix::Driver::DB->can("execute_prepared"), "execute_prepared method" );
ok( Helix::Driver::DB->can("fetch"),            "fetch method"            );
ok( Helix::Driver::DB->can("fetch_all"),        "fetch_all method"        );
ok( Helix::Driver::DB->can("free"),             "free method"             );
ok( Helix::Driver::DB->can("call"),             "call method"             );

