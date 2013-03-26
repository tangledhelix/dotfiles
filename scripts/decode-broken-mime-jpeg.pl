#!/usr/bin/env perl

use MIME::Base64;

while (<>) {
    chomp;
    $x .= $_;
}

$y = decode_base64($x);
print $y;

