package HXTests_Attributes;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/lib/HXTests_Attributes.pm - attributes test class
#
# ==============================================================================

use base qw/Helix::Core::Attributes/;
use warnings;
use strict;

# ------------------------------------------------------------------------------
# akira()
# test function, does nothing
# ------------------------------------------------------------------------------
sub akira : Yamaoka
{
}

1;

