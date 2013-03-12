#!/usr/bin/env perl
#
# parse_mail_urls.pl
#
# 02 Feb 2004 - Dan Lowe <dan@tangledhelix.com>
#
# Takes text on stdin, looks for URLs, spits them to stdout.
# Currently knows http: https: and mailto: URL formats.
#
# The algorithm is a bit sloppy, but it's intended for human consumption
# so the assumption is that the human will visually correct any stupid
# mistakes the script makes.
#
# I wrote this to be called by an Applescript, to parse URLs from
# a formatted email message.
#

use strict;

# Counts how many URLs we have seen so far.
my $counter = 0;

# Container to stick the output into.
my $output;

while (<>) {

	# This loop nibbles the line down looking for URLs, should be able
	# to handle multiple URLs per line.

	while ($_) {

		# If this line has no URL at all just end this loop,
		# then we'll end up going to the next line (in the outer loop)
		last unless m/(http(s)?|mailto):/i;

		# Nibble off the next URL and anything preceding it
		# That leading .* has to be nongreedy (.*?)
		s!^.*?((http(s)?://|mailto:)[^">\s\)\]]+)!!;

		# Snag URL match from above regex replace
		$output .= "$1\n\n";

		# Count it
		++$counter;

	}
}

# Output results

print "## I saw $counter URLs.\n\n", $output;

