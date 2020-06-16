#!/usr/bin/env perl
#
# Prints a range of numbers.  Great for stuff like this:
#
# foreach i (`nums.pl 1 1492`)
#
# Translates to:
#
# foreach i ( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ... 1490 1491 1492 )
#
# Dan Lowe <dan@tangledhelix.com>
#

use strict;
use warnings;

# Usage message in case you forgot to pass me at least two arguments
unless (defined($ARGV[1])) {
    print "Usage: $0 <startnum> <endnum>\n";
    print "   ex: $0 5 7     (will print \"5 6 7\")\n";
    print "   ex: $0 7 5     (will print \"7 6 5\")\n";
    exit;
}

my $start = $ARGV[0];
my $end = $ARGV[1];

if ($start == $end) {
    print "$start\n";
    exit;
}

if ($end > $start) {
    foreach ($start .. $end) {
        print "$_ ";
    }

} else {
    my $n = $start;
    while ($n >= $end) {
        print "$n ";
        $n--;
    }
}

print "\n";

