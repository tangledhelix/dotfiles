#!/usr/bin/env perl
#
# whoiz.pl <length> <queries>
#

use Net::DNS;

$total = 0;
$res = new Net::DNS::Resolver;
@tld = ('com','net','org');
srand( time() ^ ($$ + ($$ << 15)) );

sub whoiz {
    ($query) = @_;
    $foo = $res->query($query, "NS");

    if ($foo) {
	foreach $rr ($foo->answer) {
	    next unless $rr->type eq "NS";
	    push(@res,$rr->nsdname);
	}
    } 
    return(@res);
}

sub randlet {
    ($len) = @_;

    @rnd = ();
    $bar = 'abcdefghijklmnopqrstuvwxyz';

    for ($i=0;$i<$len;$i++) {
	$rnd = int(rand 26);
	push(@rnd,substr($bar, $rnd, 1));
    }
    $rzz = join('',@rnd);
    return($rzz);
}

sub dprint {
    ($str) = @_;
    if ($verbose) { print $str }
}

sub print {
    ($str) = @_;
    if (!$verbose) { print $str }
}

$length  = $ARGV[0];
$queries = $ARGV[1];
$verbose = 0;

for ($j=0;$j<$queries;$j++) {
    $name = randlet($length);
    if (!grep(/$name/, @checked)) {
	push(@checked, $name);
	foreach $tld (@tld) {
	    &dprint("checking $name.$tld..");
	    $total++;
	    @fzz = whoiz("$name.$tld");
	    if (@fzz) { 
		&dprint("nope\n");
	    } else {
		&dprint("free\n");
		&print("$name.$tld\n");
	    }
	}
    } else {
	&dprint("dupe: $name\n");
    }
}

print "$total total queries\n";

