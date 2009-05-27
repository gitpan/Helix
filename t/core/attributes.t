#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/core/attributes.t - attributes tests
#
# ==============================================================================  

use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More tests => 5;
use warnings;
use strict;

# ------------------------------------------------------------------------------
# BEGIN()
# test initialization
# ------------------------------------------------------------------------------
BEGIN
{
    use_ok("Helix::Core::Attributes");
    use HXTests_Attributes;
}

# methods
ok( HXTests_Attributes->can("MODIFY_CODE_ATTRIBUTES"), "MODIFY_CODE_ATTRIBUTES method" );
ok( HXTests_Attributes->can("FETCH_CODE_ATTRIBUTES"),  "FETCH_CODE_ATTRIBUTES method"  );

is
(
    HXTests_Attributes->code_cache->{"Yamaoka"}, 
    \&HXTests_Attributes::akira, 
    "code reference lookup" 
);

is_deeply
( 
    HXTests_Attributes->attr_cache->{ \&HXTests_Attributes::akira }, 
    [ "Yamaoka" ],
    "attributes lookup"
);

