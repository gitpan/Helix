#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/pod.t - POD tests
#
# ==============================================================================  

use Test::More;
use warnings;
use strict;

eval "use Test::Pod";
plan skip_all => "Test::Pod required" if $@;
plan skip_all => "set HELIX_DEVEL environment variable to enable this test" unless $ENV{"HELIX_DEVEL"};

all_pod_files_ok();

