#!/usr/bin/env perl
#
# Generate a crypt string from a particular password
#
# I forget when I originally wrote this.
#
# 6 March 2000 - upgraded to be a bit nicer in the UI department
# <dan@tangledhelix.com> Dan Lowe
#

use warnings;

print "\n      *** WARNING ***\n";
print "  Passwords will appear on the screen as you type them.\n";
print "  Make sure you know who is watching your screen!\n\n";

# Control trigger for outmost loop
$another = 'y';

while ($another !~ /^n/i) {

    # Blank password var, then get a new password from user
    undef $pw;
    print 'Enter password (minimum 6 characters): ';
    chomp($pw = <STDIN>);

    # Make sure it's at least 6 characters, for chrissake.
    while (length($pw) < 6) {
        print "Password is too short.\n";
        print 'Enter password (minimum 6 characters): ';
        chomp($pw = <STDIN>);
    }

    srand(time() ^ ($$ + ($$ << 15)));      # Generate a random salt
    $salt = chr(rand(23) + 65) . chr(rand(23) + 65);

    print '=> Crypted password: ', crypt($pw, $salt), "\n\n";

    print 'Another? [Y/n] ';
    chomp($another = <STDIN>);

}

