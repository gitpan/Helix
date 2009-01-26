package Helix::Core::CGI;
# ==============================================================================
#
#   Helix Framework
#   Copyright (c) 2009, Atma 7
#   ---
#   Helix/Core/CGI.pm - common gateway interface functions
#
# ==============================================================================

use warnings;
use strict;

our $VERSION  = "0.01"; # 2008-10-17 23:26:26

# ------------------------------------------------------------------------------
# \% new($postmax, $tmpdir)
# constructor
# ------------------------------------------------------------------------------
sub new 
{
    my ($class, $self, $cfg);

    $class = shift;
    $cfg   = Helix::Core::Config->get_instance;

    # class attributes
    $self = 
    {
        # base parameters
        "max_post_size"  => $cfg->{"cgi"}->{"max_post_size"}  || 6553600,
        "tmp_dir"        => $cfg->{"cgi"}->{"tmp_dir"}        || "/tmp/",
        "session_cookie" => $cfg->{"cgi"}->{"session_cookie"} || "SESSIONID",
 
        # input data
        "cookie" => {},
        "get"    => {},
        "post"   => {},
        "file"   => {},

        # session data
        "session" => 
        {
            "id"     => undef,
            "params" => {}
        },

        # HTTP-header for reply
        "header" => 
        {
            "content_type" => $cfg->{"cgi"}->{"content_type"} || "text/html",
            "charset"      => $cfg->{"cgi"}->{"charset"}      || "UTF-8",
            "cookie"       => [],
            "user_defined" => "",
            "is_sent"      => 0
        }
    };

    bless $self, $class;
    $self->_init;

    return $self;
}

# ------------------------------------------------------------------------------
# _init()
# class initialization
# ------------------------------------------------------------------------------
sub _init
{
    my ($self, $key, $value, $boundary, $buffer, $stage, $fh, $filename, $sid);

    $self = shift;

    # GET
    if ($ENV{"QUERY_STRING"})
    {
        foreach (split /&/, $ENV{"QUERY_STRING"}) 
        {
            ($key, $value) = map { $self->decode_string($_) } split /=/;
            next unless (defined $key);
            $self->{"get"}->{$key} = $value;
        }
    }

    # POST
    if ($ENV{"REQUEST_METHOD"} && uc($ENV{"REQUEST_METHOD"}) eq "POST")
    {
        # check POST size
        if ($ENV{"CONTENT_LENGTH"} > $self->{"max_post_size"}) { throw Error::Core::CGI::MaxPost }

        # multipart/form-data
        if ($ENV{"CONTENT_TYPE"} =~ /^multipart\/form-data/) 
        {
            # get boundary marker
            ($boundary) = $ENV{"CONTENT_TYPE"} =~ /boundary="?(\S[^"]+)"?$/;
            throw Error::Core::CGI::InvalidPOST unless ($boundary);

            $buffer = "";
            $stage = 0;

            # each line
            while (<STDIN>)
            {
                # new parameter
                ($stage == 0) && do
                {
                    if (/^--$boundary(--)?\r\n$/o)
                    {
                        $stage = $1 ? 4 : 1;
                        substr($buffer, -2) = "" if ($buffer);
                    }

                    if ($buffer)
                    {
                        if ($fh) { print $fh $buffer } else { $self->{"post"}->{$key} .= $buffer }
                        undef $buffer;
                    }

                    $stage && $fh && close $fh;
                    ($stage == 4) && last;
                    $buffer = $stage ? "" : $_;

                    next;
                };

                # parameter's header
                ($stage == 1) && /^Content-Disposition: form-data; name="?([^"\s;]+)"?(?:; (filename)="?([^"\s;]*)"?)?\r\n$/o && do
                {
                    $key = $self->decode_string($1);

                    if ($2) 
                    {
                        $stage++;

                        if ($3)
                        {
                            # file upload
                            $filename = $self->{"tmp_dir"}.$self->generate_string;
                            open $fh, ">$filename" || throw Error::Core::CGI::FileSave;

                            # file variables
                            $self->{"file"}->{$key} =
                            {
                                "name" => $3,
                                "tmp"  => $filename,
                                "ext"  => (rindex($3, ".") != -1) ? substr($3, rindex($3, ".") + 1) : undef
                            };
                        }

                        undef $filename;
                    }
                    else
                    {
                        # usual field
                        $stage += 2;
                        $self->{"post"}->{$key} = undef;
                        undef $fh;
                    }

                    next;
                };

                # content type
                ($stage == 2) && /^Content-Type: ([^\r\n]+)\r\n$/o && do 
                {
                    $self->{"file"}->{$key}->{"type"} = $1 if ($self->{"file"}->{$key});
                    $stage++;

                    next;
                };

                # empty line
                ($stage == 3) && do { $stage = 0; next };

                throw Error::Core::CGI::InvalidPOST($_.$stage);
            }
        } 
        else 
        {
            # application/x-www-form-urlencoded
            read STDIN, $buffer, $ENV{"CONTENT_LENGTH"};
            
            foreach (split /&/, $buffer) 
            {
                ($key, $value) = map { $self->decode_string($_) } split /=/;
                next unless (defined $key);
                $self->{"post"}->{$key} = $value;
            }
        }
    }

    # cookies
    if ($ENV{"HTTP_COOKIE"}) 
    {
        foreach (split /;\s*/, $ENV{"HTTP_COOKIE"}) 
        {
            ($key, $value) = map { $self->decode_string($_) } split /=/;
            $self->{"cookie"}->{$key} = $value;
        }
    }

    # session
    if (($sid = $self->get_cookie($self->{"session_cookie"})) && -f $self->{"tmp_dir"}.$sid) 
    {
       $filename = $self->{"tmp_dir"}.$sid;

       if (time - (stat $filename)[9] > 3600) 
       {
           unlink $filename;
       } 
       else 
       {
           open FILE, $filename; 

           while (<FILE>) 
           {
               chomp;
               ($key, $value) = split /\t/;
               $self->{"session"}->{"params"}->{$key} = $value;
           }

           close FILE;
           $self->{"session"}->{"id"} = $sid;
       }
    }

    # cleanup
    undef $_;
    undef $buffer;
}

# ------------------------------------------------------------------------------
# $ decode_string($string)
# decode string
# ------------------------------------------------------------------------------
sub decode_string
{
    my ($self, $string) = @_;
    
    $string =~ tr/+/ /;
	$string =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C', hex($1))/ge;

    return $string;
}

# ------------------------------------------------------------------------------
# $ \% get()
# GET parameters
# ------------------------------------------------------------------------------
sub get
{
    my ($self, $name) = @_;

    return defined $name ? $self->{"get"}->{$name} : $self->{"get"};
}

# ------------------------------------------------------------------------------
# $ \% post()
# POST parameters
# ------------------------------------------------------------------------------
sub post
{
    my ($self, $name) = @_;
 
    return defined $name ? $self->{"post"}->{$name} : $self->{"post"};
}

# ------------------------------------------------------------------------------
# \% get_file()
# file parameters
# ------------------------------------------------------------------------------
sub get_file
{
    my ($self, $name) = @_;

    return defined $name ? $self->{"file"}->{$name} : $self->{"file"};
}

# ------------------------------------------------------------------------------
# \$ receive_file($name)
# get file contents
# ------------------------------------------------------------------------------
sub receive_file
{
    my ($self, $name, $buffer) = @_;

    if ($name && $self->get_file($name))
    {
        open FILE, "<".$self->get_file($name)->{"tmp"};
        binmode FILE;
        read FILE, $buffer, -s $self->get_file($name)->{"tmp"};
        close FILE;
    }

    return \$buffer;
}

# ------------------------------------------------------------------------------
# $ get_param($name)
# get GET or POST parameter
# ------------------------------------------------------------------------------
sub get_param
{
    my ($self, $name) = @_;

    return exists $self->{"get"}->{$name}  ? $self->get($name)  :
           exists $self->{"post"}->{$name} ? $self->post($name) : undef;
}

# ------------------------------------------------------------------------------
# $ get_cookie($name)
# get cookie value
# ------------------------------------------------------------------------------
sub get_cookie
{
    my ($self, $name) = @_;

    return exists $self->{"cookie"}->{$name} ? 
                  $self->{"cookie"}->{$name} : undef;
}

# ------------------------------------------------------------------------------
# set_cookie($name, $value, $expires, $path, $domain)
# set cookie value
# ------------------------------------------------------------------------------
sub set_cookie
{
    my ($self, $name, $value, $expires, $path, $domain) = @_;

    if ($self->is_header_sent)
    {
        warn "Cannot set cookie - header is already sent";
        return;
    }

    $expires ||= 0;
    $path    ||= "/";
    $domain  ||= "";

    # compute cookie's expire date
    if ($expires) 
    {
        $expires = gmtime(time + $expires);
        $expires =~ s/^(\w+)\s+(\w+)\s+(\d+)\s+([\d:]+)\s+\d\d(\d\d)$/$1, $3-$2-$5 $4 GMT/;
    }

    # create a cookie
    push @{ $self->{"header"}->{"cookie"} }, 
    { 
        "name"    => $name, 
        "value"   => $value, 
        "expires" => $expires, 
        "path"    => $path, 
        "domain"  => $domain 
    };
}

# ------------------------------------------------------------------------------
# $ generate_string($len)
# random string generation
# ------------------------------------------------------------------------------
sub generate_string
{
    my ($self, $len, $symtable, $symlen, $str, $i);

    ($self, $len) = @_;

    $len      = 32 if (!$len);
    $symtable = join "", (0..9, "a".."z", "A".."Z");
    $symlen   = length($symtable);
    $str      = "";

    for ($i = 0; $i < $len; $i++) 
    {
        $str .= substr($symtable, int rand($symlen), 1);
    }

    return $str;
}

# ------------------------------------------------------------------------------
# init_session()
# session initialization
# ------------------------------------------------------------------------------
sub init_session
{
    my $self = shift;

    unless ($self->get_cookie($self->{"session_cookie"}))
    {
        $self->{"session"}->{"id"} = $self->generate_string(64);
        $self->set_cookie($self->{"session_cookie"}, $self->{"session"}->{"id"});
    }
}

# ------------------------------------------------------------------------------
# destroy_session()
# delete session params & destroy session's cookie
# ------------------------------------------------------------------------------
sub destroy_session
{
    my ($self, $sid);

    $self = shift;
    $sid  = $self->{"session"}->{"id"};

    return unless ($sid);

    $self->set_cookie($self->{"session_cookie"}, "");
    unlink $self->{"tmp_dir"}.$sid;
}

# ------------------------------------------------------------------------------
# set_session($key, $value)
# set session parameter
# ------------------------------------------------------------------------------
sub set_session
{
    my ($self, $key, $value) = @_;

    throw Error::Core::CGI::NoSession if (!defined $self->{"session"}->{"id"});
    
    $self->{"session"}->{"params"}->{$key} = $value;
}

# ------------------------------------------------------------------------------
# get_session($key)
# get session parameter
# ------------------------------------------------------------------------------
sub get_session
{
    my ($self, $key) = @_;

    throw Error::Core::CGI::NoSession if (!defined $self->{"session"}->{"id"});

    return $self->{"session"}->{"params"}->{$key};
}

# ------------------------------------------------------------------------------
# is_header_sent()
# check if header is sent
# ------------------------------------------------------------------------------
sub is_header_sent
{
    my $cfg = Helix::Core::Config->get_instance;

    if ($cfg->{"app"}->{"type"} == Helix::Application->TYPE_CGI)
    {
        return tell STDOUT ? 1 : 0;
    }
    elsif ($cfg->{"app"}->{"type"} == Helix::Application->TYPE_FCGI)
    {
        return $_[0]->{"header"}->{"is_sent"};
    }
}

# ------------------------------------------------------------------------------
# add_header($header)
# add user-defined header
# ------------------------------------------------------------------------------
sub add_header
{
    $_[0]->{"header"}->{"user_defined"} .= $_[1]."\n";
}

# ------------------------------------------------------------------------------
# send_header()
# send header
# ------------------------------------------------------------------------------
sub send_header
{
    my ($self, $buffer);

    $self = shift;

    if ($self->is_header_sent) 
    {
        warn "Cannot send header - header is already sent";
        return;
    }

    # add user-defined header parts
    $buffer = $self->{"header"}->{"user_defined"};
    
    # content type and charset
    $buffer .= sprintf
    (
        "Content-Type: %s; charset=%s\n", 
        $self->{"header"}->{"content_type"}, 
        $self->{"header"}->{"charset"}
    );

    # cookies
    foreach (@{ $self->{"header"}->{"cookie"} }) 
    {
        $buffer .= "Set-Cookie: $_->{'name'}=$_->{'value'};";

        if ($_->{"path"})    {$buffer .= " path=$_->{'path'};"}
        if ($_->{"expires"}) {$buffer .= " expires=$_->{'expires'};"}
        if ($_->{"domain"})  {$buffer .= " domain=$_->{'domain'};"}

        $buffer .= "\n";
    }

    $buffer .= "\n";

    # save session data
    if ($self->{"session"}->{"id"}) 
    {
        open FILE, ">", $self->{"tmp_dir"}.$self->{"session"}->{"id"};

        foreach (keys %{ $self->{"session"}->{"params"} }) 
        {
            print FILE "$_\t".$self->{"session"}->{"params"}->{$_}."\n";
        }

        close FILE;
    }

    # FCGI hack
    $self->{"header"}->{"is_sent"} = 1;

    print $buffer;
    undef $buffer;
}

# ------------------------------------------------------------------------------
# DESTROY()
# destructor
# ------------------------------------------------------------------------------
sub DESTROY
{
    unlink $_[0]->{"file"}->{$_}->{"tmp"} foreach (keys %{ $_[0]->{"file"} });
}

1;

__END__

=head1 NAME

Helix::Core::CGI - common gateway interface functions for Helix Framework.

=head1 SYNOPSIS

    use Helix::Core::CGI;

=head1 DESCRIPTION

The I<Helix::Core::CGI> class provides standart CGI functions - GET/POST
requests parsing, cookies & session handling. It's more comfortable and fast
replacement of old L<CGI> package.

=head1 METHODS

=head2 new()

Class constructor. Creates an object and calls the initialization function.

=head2 _init()

Class initialization. Parses input data - GET data, POST data, cookies and 
session variables. 

=head2 decode_string($string)

Decodes an url-encoded C<$string>.

=head2 get($name)

Returns a value of the GET parameter. If C<$name> of variable is not given,
returns a hashref with all GET parameters.

=head2 post($name)

Returns a value of the POST parameter. If C<$name> of variable is not given,
returns a hashref with all POST parameters.

=head2 get_file($name)

Returns a hashref with uploaded file data:

=over 4

=item * name

Uploaded file name. 

=item * tmp

Path to temporary file, where uploaded file contents are stored. This file is
automatically deleted during I<Helix::Core::CGI> object destruction, so you 
don't need to care about this.

=item * ext

Uploaded file extension.

=back

If C<$name> of parameter is not given, returns a hashref with all uploaded 
files.

=head2 receive_file($name)

Returns contents of the uploaded file. C<$name> - name of upload variable.

=head2 get_param($name)

Returns a value of the GET or POST parameter with the given C<$name>. If
variable C<$name> exists both in GET and POST requests, value will be taken
from first.

=head2 get_cookie($name)

Returns a cookie value.

=head2 set_cookie($name, $value, $expires, $path, $domain)

Sets a cookie. C<$expires> - is a number of seconds in which the cookie will be
expired. 

=head2 generate_string($len)

Returns a randomly-generated string with. C<$len> - length of the string to be
generated. If C<$len> is not specified, 32-character string will be generated. 

=head2 init_session()

Initialize user session. Generates a magic session ID and sets a cookie with
this value to user.

=head2 destroy_session()

Destroys the session, if any.

=head2 set_session($key, $value)

Sets session parameter C<$key> with the given C<$value>.

=head2 get_session($key)

Returns C<$key> session parameter value.

=head2 is_header_sent()

Checks if HTTP header is already sent. Returns I<1> or I<0>.

=head2 add_header($header)

Adds user-defined header string C<$header>.

=head2 send_header()

Sends HTTP header to browser.

=head1 SEE ALSO

L<Helix>, L<CGI>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Anton Belousov, E<lt>abel@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2009, Atma 7, L<http://www.atma7.com>

=cut
