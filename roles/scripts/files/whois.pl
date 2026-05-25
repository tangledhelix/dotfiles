#!/usr/bin/env perl
#
# BW whois
#
# Copyright (c) 1999-2000 William E. Weinman
# http://bw.org/whois/
#
# Designed to work with the new-mangled whois system introduced 1 Dec 1999.
#
# Under the new domain-name regime the whois system is now distributed 
# amongst the various domain-police^H^H^H^H^H^H^H^H^H^H registrars, thereby 
# requiring that we make at least two separate requests (to two separate 
# servers) for each whois record. 
#
# This program will first go to the "root" whois server and ask for a record. 
# If found, the root server will tell us where to go get the actual record, and 
# then we go get it. 
#
# Additional feature: If this program gets back a list of references instead 
# of a single record (as in the case of a record with a domain name for an 
# organization name), it will go out one more time and fetch the actual 
# record using the bang-handle. This became necessary because the "root" 
# whois server doesn't know where to tell you to go for a handle. Messy. 
#
# This program is free software. You may modify and distribute it under 
# the same terms as perl itself. 
#
# version 1.0 -- wew 2 Dec 1999  -- first release
# version 1.1 -- wew 3 Dec 1999 
#                   added --stripheader (by popular demand)
#                     thanks to Bill Shupp <hostmaster@shupp.org> for the concept.
#                   also -- now prints "Registrar: <host>" line (unless quiet)
# version 1.2 -- wew 3 Dec 1999
#                   added new syntax for specifying a host. can now say:
#                        whois <request>@<host>   as a synonym for: 
#                        whois -h <host> <request>
#                     thanks to Rob Friedman <playerx_@hotmail.com> for suggesting
#                     this feature. 
# version 1.3 -- wew 5 Dec 1999 
#                   added check for IP numbers or 'NETBLK' and set default to ARIN
#                     thanks to "Todd R. Eigenschink" <todd@tekinteractive.com>
#                   fixed an "uninitialized variable" problem. 
#                     thanks again to "Todd R. Eigenschink" <todd@tekinteractive.com>
# version 1.4 -- wew 8 Dec 1999 
#                   a hack for a mis-feature in the root whois server 
#                   at whois.internic.net. it seems to have a small number 
#                   of records that are not 2nd-level domains but are named 
#                   the same as existing 2nd-level domains. I added a test 
#                   for a valid 2nd-level domain in whois_fetch() and have it 
#                   request the record as a domain. 
#                     thanks to Rick Macdougall <rickm@axess.com>
# version 1.4a -- wew 8 Dec 1999 
#                   whois.corenic.net doesn't undderstand the domain command
#                   -- I guess the concept of standardization is lost on 
#                   these folks. Anyway, now I only send the domain command 
#                   to whois.internic.net. 
#                     thanks to Cooper Vertz <cooper@cooper8.com> for 
#                     pointing this out. 
# version 2.0 -- wew 6 Jan 2000
#                   first public release of the 2.0 version
#                   rewrote and cleaned up a whole bunch of stuff
#                   added CGI support
# version 2.1 -- wew 6 Jan 2000
#                   added support for optional TLD table at /etc/tld.conf
# version 2.2 -- wew 10 March 2000
#                   bugfix: all-numeric addresses were still tested for TLD
#                   add support for multiple domain names on the command line. 
#                     thanks to Paul Vincent <paul@anglia-web.co.uk> for 
#                     suggesting this feature
#                   generalized the stripheader option
#                   added support for netblock references (e.g. RIPE, APNIC)
# version 2.21 -- wew 11 March 2000
#                   bugfix -- uninitialized variable bug
# version 2.3 -- 
#                   bugfix -- ARIN changed their whois display in a manner 
#                     broke my referral-detection. I've added a new exception 
#                     for whois.nic.mil. 
#                   add environment variable support. 
#                     BW_WHOIS="stripheader" to default to strip headers
#                     BW_WHOIS="quiet" to default to quiet mode
#                     BW_WHOIS="stripheader:quiet" for both
#                   CGI mode: attempt to build a reasonable link to 
#                     related records (e.g. NIC handles)
#                     Note: this feature uses the RFC-954 "!" syntax to 
#                     look up the handle. Not all registrars support this. 
#

# TODO -- handle chroot problem for tld.conf in CGI mode. 

use strict;
use warnings;
use vars qw( $env $host $quiet $stripheader $default_host $internic $netblk_host ); 
use IO::Socket;
use Getopt::Long;

# the location (full path) of your html file for CGI mode
my $htmlfile = "/var/web/bearnet/luna/whois.html";
my $tld_conf = "/etc/tld.conf";

### no need to modify anything below here ### 

my $cgi = $ENV{SCRIPT_NAME} || '';

use constant TRUE      => 1;
use constant FALSE     => '';

use subs qw{ _print error };

my $host = '';
my $quiet = '';
my $help = '';
my $html = '';
my $_version = '';
my $stripheader = '';
my $makehtml = '';

my $version = "2.3";
my $_c = $cgi ? '&copy;' : 'Copyright';
my $copyright = "$_c 1999-2000 William E. Weinman";
my $progname = $cgi ? '<a href="http://bw.org/whois/">BW whois</a>' : 'BW whois' ;
my $byline = $cgi ? '<a href="http://bw.org/">Bill Weinman</a>' : 'Bill Weinman <http://bw.org/>';
my $banner = $cgi ? "$progname $version by $byline\n$copyright\n\n" : "$progname $version by $byline\n$copyright\n";

my $gtlds        = '(com|net|org)';
my $internic     = 'whois.internic.net';
my $default_host = $internic;               # starting point
my $netblk_host  = 'whois.arin.net';        # default host for netblocks
my $portname = 'whois(43)';
my $protoname = 'tcp';

# the text to test against for the end of a header with -s
my $headerstop = q{you agree to abide};

my $outstr = '';
my $q = '';

++ $|;
if($cgi) { 
  print "Content-type: text/html\n\n";
  $q = getquery();
  do_cgi();
  exit;
  }
else {

  if($env = $ENV{BW_WHOIS}) {
    $env =~ /stripheader/ and $stripheader = TRUE;
    $env =~ /quiet/ and $quiet = TRUE;
    }

  GetOptions(
               "host=s" => \$host, 
               "h=s" => \$host, 
               "stripheader!" => \$stripheader, 
               "makehtml!" => \$makehtml, 
               "quiet!" => \$quiet,
               "html!" => \$html,
               "help!" => \$help,
               "version!" => \$_version
               ) or usage();

  usage() if $help;
  version() if $_version;

  if($makehtml) { 
    print defaulthtml();
    exit;
    }

  usage() unless @ARGV;

  # signon
  _print $banner unless $quiet;

  while(my $domain = shift) { whois($domain) }
  exit 0;
  }

sub do_cgi
{
my $domain = $q->{domain} || '';
my $h = '';

++$stripheader if $q->{stripheader};

if($domain) { whois($domain) };

$outstr = $banner .= $outstr; 

if($htmlfile and -f $htmlfile) {
  open(HF, "<$htmlfile") or error "cannot open $htmlfile: $!\n";
  while(<HF>) { $h .= $_ }
  close HF;
  }
else { $h = defaulthtml(); }

$h =~ s/\$SELF\$/$cgi/gs;
$h =~ s/\$DOMAIN\$/$domain/gs;
$h =~ s/\$RESULT\$/$outstr/gs;

print $h;
}

sub whois
{
my $domain = shift;
my $tld = '';
my $r_host = $host;
my $netblock = FALSE;
my $r_default_host = $default_host;

_print "Request: $domain\n";

# support for the <request>@<domain> syntax ...
unless ($r_host) { ($domain, $r_host) = split /\@/, $domain; }

# is it a netnum or NETBLK? try ARIN first
if($domain =~ /^([\d\.]+$|!?NET(BLK)?-)/i) {
  $r_default_host = $netblk_host if $domain =~ /^([\d\.]+$|!?NET(BLK)?-)/i;
  _print "using netblock server $netblk_host\n";
  $netblock = TRUE;
  }

my @rc = ();
my $subrec = '';

# do we need a different default server?
if(!$r_host and $r_default_host ne $netblk_host and $domain =~ /\.([a-z0-9\-]+)$/) {
  $tld = $1;
  if($tld !~ /$gtlds/) {
    my $tld_host = find_tld($tld);
    $r_default_host = $tld_host if $tld_host;
    } 
  }

# Go Fishin' at the default host ... 
unless($r_host) {
  $r_host = FALSE;
  @rc = whois_fetch($r_default_host, $domain);
  if($netblock) {    # is there another whois server referenced? 
    # first check for a host named whois.something...
    grep { /(whois\.[\w-.]*)/ig and $r_host = $1 unless $r_host } @rc;
    # otherwise, check for a host preceeded by the word "whois"
    grep { 
         /whois\b.*?([\w-]+\.[\w-.]*)/i and $r_host = $1 unless $r_host;
         # the following test is necessary because all ARIN records have the following string: 
         # "Please use the whois server at rs.internic.net for DOMAIN related"
         $r_host = '' if $r_host eq 'rs.internic.net' || 'whois.nic.mil';
         } @rc;
    }
  else {
    grep { /Whois Server:\s*(.*)/i and $r_host = $1 } @rc;   # look for the referral
    }
  }

# now we know where to look -- let's go get it
if($r_host) {
  @rc = whois_fetch($r_host, $domain);
  grep {/\((.*-DOM)\).*$domain$/i and $subrec = $1 } @rc;
  }

# do we have a sub rec? If so, "Fetch!"
if($subrec) {
  _print "found a reference to $subrec ... requesting full record ...\n" unless $quiet;
  @rc = whois_fetch($r_host, $subrec);
  }

# tell 'em what we found ...
_print "Registrar: $r_host\n" if (@rc && $r_host && !$quiet);
my $headerflag = ($stripheader && $r_host && grep(/$headerstop/, @rc));
while(@rc) {
  my $l = shift @rc;
  _print $l unless $stripheader && $headerflag;
  if($stripheader) {
    $headerflag = FALSE if($l =~ /$headerstop/i);
    }
  }
}

sub whois_fetch
{
my $host = shift;
my $domain = shift;
my ($uri, $handle);
my @rc;

if($html or $cgi) {
  # RFC-954 whois servers (e.g. whois.networksolutions.com) require the "!" 
  # to look up handles, while other whois servers (e.g. RIPE) prohibit it. 
  # I search for the double-dash option as that is often used on those servers
  $handle = ($host =~ /whois.corenic.net/) ? '' : '%21';
  $uri = $cgi || $ENV{_SCRIPT_NAME} || 'whois';
  }

my $rs = IO::Socket::INET->new(
    PeerAddr  => $host,
    PeerPort  => $portname,
    Proto     => $protoname
  ) or error "$host not found\n";
my $IP = $rs->peerhost; 
_print "connecting to $host [$IP] ... \n" unless $quiet;
$rs->autoflush(1);

# if it's a valid 2nd-level domain name, treat it as one. 
if($domain =~ /^[a-z\d\-]+\.[a-z\d\-]+$/ and $host eq $internic) { 
  $rs->print("domain $domain\r\n"); 
  }
else { $rs->print("$domain\r\n"); }
while(<$rs>) { 
  s/
    \((                    # a handle is in parens ...
      [A-Z]                # ... is all UPPERCASE and starts with a letter
      [A-Z0-9-_]+?)\)      # ... may contain digits, dashes, and underscores

    /(<a href="$uri?domain=$handle$1%40$host&stripheader=$stripheader">$1<\/a>)/gsx
    if ($html or $cgi);

  push @rc, $_;
  }
return @rc;
}

sub version { print $banner, "\n"; exit }

sub usage
{
print $banner;
print <<USAGE;

usage: whois [options] (<request> | <request>@<host>) [ ... ]

options: 

  --help         Show this screen

  --host <host>  Hostname of the whois server
  -h <host>      this is the same as the <request>@<host> form
                 if not specified will search $default_host
                 for a "Whois Server:" record

  --quiet        Don't print any extraneous messages. 
  -q             ... "just the facts, ma'am"

  --stripheader  Strip off that silly disclaimer from the 
  -s             whois.networksolutions.com server. You've 
                 read it a thousand times already, right?

  --makehtml     Display example HTML file. Prints a small 
                 file to STDOUT with the example HTML in it. 
                 Use this to modify to your own taste for CGI 
                 mode. Change \$htmlfile variable as needed. 

USAGE
exit;
}

# getquery
#
# returns hash of CGI query strings
# works with GET, POST, and multipart methods
#
sub getquery
{
my $method = $ENV{'REQUEST_METHOD'} || 'none';
my ($query_string, $pair);
my %query_hash;
my $ct = $ENV{CONTENT_TYPE} || '';

my ($count, $x, $boundary, $chunk, $i, $filect, $_qsname, $_qsvalue);
my @chunks;

if($ct =~ /^multipart/) {
  # process multipart query
  $count = read STDIN, $x, $ENV{CONTENT_LENGTH}; 
  ($boundary) = $ct =~ /boundary=(.*)$/;
  @chunks = split /\r?\n?--$boundary-?-?\r\n/, $x;
  for $chunk (@chunks) { 
    my ($header, $data) = split /\r\n\r\n/, $chunk;
    my @lines = split /\r\n/, $header; chomp @lines;
    if($lines[0] =~ /$boundary/) { shift @lines }  # loose any leftover boundary strings
    if($lines[0] =~ /filename=/i) {   # it's a file
      for($i = 1; $i < @lines; $i++) {
        if($lines[$i] =~ /^content-type:\s*(\S*)/i) { 
          $filect = $1;
          last;
          }
        }
      $query_hash{_datatype} = $filect;
      $query_hash{_datafile} = $data;
      next;
      }
    for($i = 0; $i < @lines; $i++) { 
      my $thisline = $lines[$i];
      if ($thisline =~ /^Content-disposition: form-data; name="?(\w+)"?/i) {
        $_qsname = $1;
        $_qsvalue = $data;
        $query_hash{$_qsname} = $_qsvalue;
        }
      }
    }
  }

else {
  $query_string = $ENV{'QUERY_STRING'} if $method eq 'GET';
  $query_string = <STDIN> if $method eq 'POST';
  $query_string = $ARGV[0] if $method eq 'none';
  return () unless $query_string;

  foreach $pair (split(/&/, $query_string)) {
    ($_qsname, $_qsvalue) = split(/=/, $pair);
    $_qsvalue =~ s/\+/ /g;
    $_qsvalue =~ s/%([\da-f]{2})/pack('c',hex($1))/ieg;
    $query_hash{$_qsname} = $_qsvalue;
    # if it's an image element, make an extra entry for just the name
    if($_qsname =~ /(.*)\.x$/) { $query_hash{$1} = "image" }
    }
  }
return \%query_hash;
}

sub defaulthtml
{
return q{<!--  

  BW whois example HTML file
  Copyright 1999-2000 William E. Weinman  http://bw.org/  

  Placeholders are used for the various values which make this 
  work. These placeholders are represented by text enclosed in 
  '$' signs like this: 

    $PLACEHOLDER$

  The placeholders are: 

    SELF    The URI path of the program on your web server, taken 
            from the value of the SCRIPT_NAME environment variable. 

    DOMAIN  The domain that was last looked up, if any. 

    RESULT  The result of the whois query from BW whois. 

  See the example (below) for specific usage. 

  Bonus: Add a hidden field to supress the NSI disclaimer like this: 
    <input type=hidden name=stripheader value=1> 

-->

<html>
<title> BW whois &middot; Online Query </title>

<body>

<h2> <a href="http://bw.org/whois/">BW whois</a> &middot; Online Query </h2>

<p>
<form action="$SELF$" method=post>
Enter a domain name: <br>
<input type=text name=domain value="$DOMAIN$">
<input type=submit>
</form>

<p><pre>
$RESULT$
</pre></p>
</body>
</html>

<!-- end of example HTML file for BW whois -->
}
}

sub _print
{
if($cgi) {
  while (@_) { $outstr .= shift }
  }
else { print @_ }
}

sub error
{
if($cgi) {
  my $em = ''; while (@_) { $em .= shift }
  print qq{
    <body bgcolor=white><title> BW Whois Error </title>
    <h1> Error </h1> <p> <em> $em </em>
    };
  }
else {
  die @_;
  }
}

sub find_tld
{
my $tld = shift;
my $server = '';
return FALSE unless $tld_conf and -f $tld_conf;

open(TLD, "<$tld_conf") or error "can't open $tld_conf ($!)\n";
while(<TLD>) {
  if(/^$tld\s*([a-z0-9.-]*)/) {
    $server = $1;
    last;
    }
  }
close TLD;
_print "whois server for TLD .$tld is $server ...\n" unless $quiet;
return $server;
}

