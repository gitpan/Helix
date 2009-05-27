#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/debug.t - debugging tests
#
# ==============================================================================  

use Test::More tests => 8;
use warnings;
use strict;

# should use "use_ok" instead, but it hooks die handler and overrides ours, so 
# die handler test will fail
eval
{
    use Helix::Debug; 
};

# error check
ok( !$@,                                    "use Helix::Debug" );

# methods
ok( Helix::Debug->can("start_console"),     "start_console method" );
ok( Helix::Debug->can("get_stack"),         "get_stack method"     );
ok( Helix::Debug->can("print_stack"),       "print_stack method"   );
ok( Helix::Debug->can("warn"),              "warn method"          );
ok( Helix::Debug->can("die"),               "die method"           );

# error and warning handlers
is( $SIG{"__DIE__"},  \&Helix::Debug::die,  "error handler"    );
is( $SIG{"__WARN__"}, \&Helix::Debug::warn, "warning handler"  );

