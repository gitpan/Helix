#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/driver/log.t - generic log driver tests
#
# ==============================================================================  

use Test::More tests => 7;
use warnings;
use strict;

# ------------------------------------------------------------------------------
# BEGIN()
# test initialization
# ------------------------------------------------------------------------------
BEGIN
{
    use_ok("Helix::Driver::Exceptions");
    use_ok("Helix::Driver::Log");
}

# methods
ok( Helix::Driver::Log->can("open"),    "open method"    );
ok( Helix::Driver::Log->can("close"),   "close method"   );
ok( Helix::Driver::Log->can("notice"),  "notice method"  );
ok( Helix::Driver::Log->can("warning"), "warning method" );
ok( Helix::Driver::Log->can("error"),   "error method"   );

