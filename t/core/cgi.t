#!/usr/bin/perl
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   t/core/cgi.t - CGI tests
#
# ==============================================================================  

use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More tests => 33;
use HXTests_CGI;
use warnings;
use strict;

my ($cfg, $cgi, $e);

# ------------------------------------------------------------------------------
# BEGIN()
# test initialization
# ------------------------------------------------------------------------------
BEGIN
{
    use_ok("Helix::Core::Exceptions");
    use_ok("Helix::Core::Config");
    use_ok("Helix::Core::CGI");
}

# methods
ok( Helix::Core::CGI->can("decode_string"),   "decode_string method" );
ok( Helix::Core::CGI->can("get"),             "get method"           );
ok( Helix::Core::CGI->can("post"),            "post method"          );
ok( Helix::Core::CGI->can("get_query"),       "get_query method"     );
ok( Helix::Core::CGI->can("get_file"),        "get_file method"      );
ok( Helix::Core::CGI->can("receive_file"),    "receive_file method"  );
ok( Helix::Core::CGI->can("get_param"),       "get_param method"     );
ok( Helix::Core::CGI->can("get_cookie"),      "get_cookie"           );
ok( Helix::Core::CGI->can("set_cookie"),      "set_cookie"           );
ok( Helix::Core::CGI->can("generate_string"), "generate_string"      );
ok( Helix::Core::CGI->can("start_session"),   "start_session"        );
ok( Helix::Core::CGI->can("destroy_session"), "destroy_session"      );
ok( Helix::Core::CGI->can("session_started"), "session_started"      );
ok( Helix::Core::CGI->can("set_session"),     "set_session"          );
ok( Helix::Core::CGI->can("get_session"),     "get_session"          );
ok( Helix::Core::CGI->can("header_sent"),     "header_sent"          );
ok( Helix::Core::CGI->can("add_header"),      "add_header"           );
ok( Helix::Core::CGI->can("redirect"),        "redirect"             );
ok( Helix::Core::CGI->can("send_header"),     "send_header"          );

# GET request
$ENV{"QUERY_STRING"}   = "i=ve&got=a&poison=i&ve=got&a=remedy";
$ENV{"REQUEST_METHOD"} = "GET";

$cfg = Helix::Core::Config->new("CGI test", 0);
$cgi = Helix::Core::CGI->new;

is( $cgi->get("i"),       "ve", "GET parameters passing #1"                    );
is( $cgi->get("poison"),  "i",  "GET parameters passing #2"                    );
is( $cgi->get_param("i"), "ve", "GET parameters passing: (alternative syntax)" );

undef $cgi;

{
    no warnings;
    undef $Helix::Core::CGI::INSTANCE;
}

# POST request
$ENV{"QUERY_STRING"}   = "";
$ENV{"REQUEST_METHOD"} = "POST";
$ENV{"CONTENT_LENGTH"} = length($HXTests_CGI::post);
$ENV{"CONTENT_TYPE"}   = "application/x-www-form-urlencoded";
tie *STDIN, "HXTests_CGI";

$cgi = Helix::Core::CGI->new;

is( $cgi->post("i"),      "ve", "POST parameters passing #1"                   );
is( $cgi->post("poison"), "i",  "POST parameters passing #2"                   );
is( $cgi->get_param("i"), "ve", "POST parameters passing (alternative syntax)" );

undef $cgi;

{
    no warnings;
    undef $Helix::Core::CGI::INSTANCE;
}

# POST request (multipart/form-data)
$ENV{"QUERY_STRING"}   = "";
$ENV{"REQUEST_METHOD"} = "POST";
$ENV{"CONTENT_LENGTH"} = length($HXTests_CGI::post_multipart);
$ENV{"CONTENT_TYPE"}   = "multipart/form-data; boundary=\"peoplecanfly\"";
tie *STDIN, "HXTests_CGI";

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

