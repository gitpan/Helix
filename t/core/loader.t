#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/core/loader.t - driver loader tests
#
# ==============================================================================  

use Test::More tests => 6;
use warnings;
use strict;

my ($loader, $object);

# ------------------------------------------------------------------------------
# BEGIN()
# test initialization
# ------------------------------------------------------------------------------
BEGIN
{
    use_ok("Helix::Core::Registry");
    use_ok("Helix::Core::Loader");
}

# methods
ok( Helix::Core::Loader->can("load"),       "load method"       );
ok( Helix::Core::Loader->can("get_object"), "get_object method" );

# driver loading
$loader = Helix::Core::Loader->new;
$loader->load("Helix::Driver::Router");
$object = $loader->get_object("Helix::Driver::Router");

ok( $object,                              "driver loading" );
is( ref $object, "Helix::Driver::Router", "object type"    );

