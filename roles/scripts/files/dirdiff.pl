#!/usr/bin/env perl
#
# dirdiff V 1.0, DAPM 
#
# (C) 2000 Dave.Mitchell@fdgroup.com
#
# compare 2 directory heirarchies.
# A bit like diff -r, BUT
# * it doesnt try to expand symbolic links
# * but it will tell you if 2 symlinks are different
# * it doesnt try to list differences between files, it just
# * lists which files/dirs are different
# * it shows which files have different permissions
# * it wont try comparing special files etc
# * it doesnt list the full pathname, just the common component
#
# output consists of a list of files, prefixed by one of the following chars:
# - file	file only exists in 1st dir
# + file	file only exists in 2nd dir
# ! file	the 2 files differ
# @ file	the 2 files are symbolic links with different values
# t file	the 2 files are of different types (eg reg file/sym link)
# p file	the 2 files are the identical, but have different permissions

# cmpbyte;
#
# compare 2 files byte-by-byte
# return 0 if same, 1 if different

use warnings;

$bufsize = 8192;
$buf1 = ' ' x $bufsize;
$buf2 = ' ' x $bufsize;

sub cmpbyte {
	local($path) = @_;

	local(*FD1, *FD2, $r1, $r2);

	unless(open(FD1,"$DIR1/$path")) {
		print STDERR "cant open $DIR1/$path: $!\n";
		return 1;
	}
	unless(open(FD2,"$DIR2/$path")) {
		print STDERR "cant open $DIR2/$path: $!\n";
		return 1;
	}
	for (;;) {
		$r1 = read(FD1,$buf1,$bufsize);
		unless(defined($r1)) {
			print STDERR "error reading $DIR1/$path: $!\n";
			return 1;
		}
		$r2 = read(FD2,$buf2,$bufsize);
		unless(defined($r2)) {
			print STDERR "error reading $DIR2/$path: $!\n";
			return 1;
		}
		# we assume that if we're reading a regular file, we'll always
		# be given $bufsize bytes except at eof
		if ($r1 != $r2)		{ return 1; }
		if ($r1 == 0)		{ return 0; }
		if ($buf1 ne $buf2)	{ return 1; }
	}
}

# enumeration types for cmpfile

$isafile=0;
$isalink=1;
$isadir =2;
$isnot  =3;

# cmpfile;
#
# compare the 2 files $DIR1/$path $DIR2/$path:
# do trivial checks like they are different types, different lengths
# etc. Failing that, do a byte-by-byte compare. As a last resort, see if
# the permissions are different. If they are both dirs, recursively call
# cmpdir

sub cmpfile {
	local($path) = @_;

	local(@stat1, @stat2, $type1,$type2);

	@stat1 = lstat("$DIR1/$path");
	if    (-d _)	{ $type1 = $isadir; }
	elsif (-l _)	{ $type1 = $isalink; }
	elsif (-f _)	{ $type1 = $isafile; }
	else		{ $type1 = $isnot; }
	@stat2 = lstat("$DIR2/$path");
	if    (-d _)	{ $type2 = $isadir; }
	elsif (-l _)	{ $type2 = $isalink; }
	elsif (-f _)	{ $type2 = $isafile; }
	else		{ $type2 = $isnot; }

	if ($type1 != $type2) { print "t $path\n"; return; }
	if ($type1 == $isadir){ &cmpdir($path); return; }
	if ($type1 == $isalink) {
		if (readlink("$DIR1/$path") ne readlink("$DIR2/$path")) {
			print "@ $path\n";
		}
		return;
	}
	# XXX we really aught to do more checks here, eg are they the same
	# char special device, or what
	if ($type1 == $isnot) { return; }
	
	# they're plain files: see if they match

	# stat[7] is st_size;
	if (($stat1[7] != $stat2[7]) || &cmpbyte($path)) {
		print "! $path\n"; return; }
	
	# finally, see if the permissions & ownerships are different

#	if (($stat1[2] != $stat2[2]) || # mode
#	    ($stat1[4] != $stat2[4]) || # uid
#	    ($stat1[5] != $stat2[5]))   # gid
#	{ print "p $path\n"; }
	if ($stat1[4] != $stat2[4]) {
		print "u $path\n"; return;	# differing UIDs
	}
	if ($stat1[5] != $stat2[5]) {
		print "g $path\n"; return;	# differing GIDs
	}
	if ($stat1[9] != $stat2[9]) {
		print "m $path\n"; return;	# differing mtimes
	}
}


# cmpdir;
#
# recusrsively compare 2 directories, whose paths are
# $DIR1$path, $DIR2$path
# it is assumed that both these are valid directories

sub cmpdir {
	local($path) = @_;
	local($path1,$path2,@dir1,@dir2,*DIR,$file1,$file2,$diff,$i);

	$path1 = "$DIR1/$path";
	$path2 = "$DIR2/$path";

	# suck in the 2 directory contents

	unless (opendir(DIR,$path1)) {
		print STDERR "Couldnt open $path1\n";
		return;
	}
	@dir1 = readdir(DIR);
	closedir(DIR);
	splice(@dir1,0,2);	# remove . and ..
	@dir1 = sort(@dir1);

	unless (opendir(DIR,$path2)) {
		print STDERR "Couldnt open $path2\n";
		return;
	}
	@dir2 = readdir(DIR);
	closedir(DIR);
	splice(@dir2,0,2);	# remove . and ..
	@dir2 = sort(@dir2);
	closedir(DIR);

	# see if the directories differ

	$diff=0;
	if ($#dir1 == $#dir2) {
		for ($i=0; $i<=$#dir1; $i++) {
			if ($dir1[$i] ne $dir2[$i]) {
				$diff=1; last;
			}
		}
	}
	else {$diff = 1;}

	if ($diff) { print "! $path/\n"; }

	while (@dir1 && @dir2) {
		$file1 = shift(@dir1);
		$file2 = shift(@dir2);
		if ($file1 lt $file2) {
			print "- $path/$file1\n";
			unshift(@dir2,$file2);
			next;
		}
		elsif ($file1 gt $file2) {
			print "+ $path/$file2\n";
			unshift(@dir1,$file1);
			next;
		}

		&cmpfile("$path/$file1");
	}
	# list any trailing non-common filenames
	while(@dir1) {
		$file1 = shift(@dir1);
		print "- $path/$file1\n";
	}
	while(@dir2) {
		$file2 = shift(@dir2);
		print "+ $path/$file2\n";
	}
}


if (@ARGV != 2) { die "usage: $0: dir1 dir2\n"; }

$DIR1 = $ARGV[0];
$DIR2 = $ARGV[1];

# XX aught to check that DIR1,2 are valid dirs

&cmpdir('.');

