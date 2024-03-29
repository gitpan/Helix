#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Makefile.PL - makefile maker
#
# ==============================================================================  

use 5.008008;
use ExtUtils::MakeMaker;
use warnings;
use strict;

WriteMakefile
(
    "NAME"          => "Helix",
    "ABSTRACT_FROM" => "lib/Helix.pm",
    "VERSION_FROM"  => "lib/Helix.pm", 
    "AUTHOR"        => "Anton Belousov <abel\@cpan.org>",
    "EXE_FILES"     => [ "bin/helix" ],

    "PREREQ_PM"     => 
    {
        "DBI"                   => 0,
        "Exporter"              => 0,
        "FindBin"               => 0,
        "Getopt::Long"          => 0,
        "List::Util"            => 0,
        "Class::Accessor::Fast" => 0
    }, 

    "test"          => { "TESTS" => "t/*.t t/core/*.t t/driver/*.t" },
);

