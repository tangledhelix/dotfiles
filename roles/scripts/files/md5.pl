#!/usr/bin/env perl

use Digest::MD5;

print 'Enter string: ';
chomp($data = <STDIN>);

$dhex = Digest::MD5::md5_hex($data);
$dbase = Digest::MD5::md5_base64($data);

print <<EOF;
hex = $dhex
base64 = $dbase
EOF
