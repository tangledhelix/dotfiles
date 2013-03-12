#!/usr/bin/env perl

for ($bits = 32; $bits >= 0; $bits--) {
	$netmask = join('.', unpack('CCCC',
			pack('N', 2 ** 32 - 2 ** (32 - $bits))));
	printf "%2s %s\n", $bits, $netmask;
}

