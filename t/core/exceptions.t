#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/core/exceptions.t - exceptions tests
#
# ==============================================================================  

use Test::More tests => 16;
use warnings;
use strict;

# ------------------------------------------------------------------------------
# BEGIN()
# test initialization
# ------------------------------------------------------------------------------
BEGIN
{
    use_ok("Helix::Core::Exception");
    use_ok("Helix::Core::Exception::Builder");
    use_ok("Helix::Core::Exceptions");
}

# methods
ok( Helix::Core::Exception->can("throw"),          "throw method"          );
ok( Helix::Core::Exception->can("rethrow"),        "rethrow method"        );
ok( Helix::Core::Exception->can("overloaded_equ"), "overloaded_equ method" );
ok( Helix::Core::Exception->can("overloaded_str"), "overloaded_str method" );

eval
{
    # will die
    throw Helix::Core::Exception("test 0123456789");
};

# generic exception tests
ok( $@,                              "exception throw"       );
ok( $@ eq "Helix::Core::Exception",  "exception type"        );
is( $@->line,    35,                 "exception line number" );
is( $@->message, "test 0123456789",  "exception message"     );

like( $@->file, qr/exceptions\.t$/,  "file name"             );
like( "$@",     qr/^Base exception/, "exception string"      );

eval
{
    # will die here too
    throw HXError::Core::Compile;
};

# core exception tests
ok( $@,                             "core exception"         );
ok( $@ eq "HXError::Core::Compile", "core exception type"    );
ok( $@ eq "Helix::Core::Exception", "exception inheritance"  );

