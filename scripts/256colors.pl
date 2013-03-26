#!/usr/bin/env perl

foreach my $color (0 .. 255) {

    # set the background color and print a block of spaces
    print "\x1b[48;5;${color}m            ";

    # Reset to default colors, then print the color number
    print "\x1b[0m   $color   ";

    # Set foreground color, then show me a sample of text
    print "\x1b[38;5;${color}mSample Text   ";

    # Set bold, and show me another sample text
    print "\x1b[1mSample (bold)   ";

    # Reset to default colors, and show me the escape codes
    print "\x1b[0m\\[\\033[48;5;${color}m\\]";

    # full reset, then a new line
    print "\x1b[m\n";

}

print "\n";

