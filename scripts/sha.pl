#!/usr/bin/env perl

use strict;
use warnings;

use SHA;
use MIME::Base64;

print 'Enter pass: ';
chomp($pass = <STDIN>);

my $sha = new SHA;
my $SHA_pass = encode_base64($sha->hash($pass));
chomp($SHA_pass);
$SHA_pass =~ s/\s//g;
print "pass is '$SHA_pass'\n";
