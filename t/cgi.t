#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/cgi.t - CGI tests
#
# ==============================================================================  

use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More tests => 14;
use CGI_STDIN;
use warnings;
use strict;

my ($cfg, $cgi, $e);

BEGIN
{
    use_ok("Helix::Core::Exception::List");
    use_ok("Helix::Core::Config");
    use_ok("Helix::Core::CGI");
}

# GET request
$ENV{"QUERY_STRING"}   = "i=ve&got=a&poison=i&ve=got&a=remedy";
$ENV{"REQUEST_METHOD"} = "GET";

$cfg = Helix::Core::Config->new("CGI test", 0);
$cgi = Helix::Core::CGI->new;

is($cgi->get("i"),       "ve", "GET parameters passing #1");
is($cgi->get("poison"),  "i",  "GET parameters passing #2");
is($cgi->get_param("i"), "ve", "GET parameters passing: (alternative syntax)");

undef $cgi;

{
    no warnings;
    undef $Helix::Core::CGI::INSTANCE;
}

# POST request
$ENV{"QUERY_STRING"}   = "";
$ENV{"REQUEST_METHOD"} = "POST";
$ENV{"CONTENT_LENGTH"} = length($CGI_STDIN::post);
$ENV{"CONTENT_TYPE"}   = "application/x-www-form-urlencoded";
tie *STDIN, "CGI_STDIN";

$cgi = Helix::Core::CGI->new;

is($cgi->post("i"),      "ve", "POST parameters passing #1");
is($cgi->post("poison"), "i",  "POST parameters passing #2");
is($cgi->get_param("i"), "ve", "POST parameters passing (alternative syntax)");

undef $cgi;

{
    no warnings;
    undef $Helix::Core::CGI::INSTANCE;
}

# POST request (multipart/form-data)
$ENV{"QUERY_STRING"}   = "";
$ENV{"REQUEST_METHOD"} = "POST";
$ENV{"CONTENT_LENGTH"} = length($CGI_STDIN::post_multipart);
$ENV{"CONTENT_TYPE"}   = "multipart/form-data; boundary=\"peoplecanfly\"";
tie *STDIN, "CGI_STDIN";

$cgi = Helix::Core::CGI->new;

is
(
    $cgi->post("astral"),
    "projection",
    "POST parameters passing (multipart/form-data)"
);

is
(
    $cgi->get_file("text")->{"name"}, 
    "base_001.txt", 
    "POST file upload (filename)"
);

like
(
    $cgi->get_file("text")->{"tmp"}, 
    qr/^\/tmp/, 
    "POST file upload (temporary path)"
);

is
(
    $cgi->get_file("text")->{"ext"},   
    "txt",      
    "POST file upload (extension detection)"
);

is
(
    ${ $cgi->receive_file("text") },   
    "All your base are belong to us.", 
    "POST file upload (reading file contents)"
);

