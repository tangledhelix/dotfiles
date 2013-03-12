#!/usr/bin/env perl

foreach (@ARGV) {
	print "\n" if $not_first++;
	&xstat($_);
}

sub xstat {
	local($filename) = @_;
	($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size,
		$atime, $mtime, $ctime, $blksize, $blocks) = stat($filename);
	$login = (getpwuid($uid))[0];
	$gname = (getgrgid($gid))[0];
	printf("fdevice\t%u\n", $dev);
	print "inode\t", $ino, "\n";
	printf("mode\t%o\n", $mode);
	print "links\t", $nlink, "\n";
	print "uid\t", $uid, "\t(", $login, ")\n";
	print "gid\t", $gid, "\t(", $gname, ")\n";
	print "maj\t", $rdev>>8, "\n";
	print "min\t", $rdev&255, "\n";
	print "size\t", $size, "\n";
	print "atime\t", $atime, "\t(", &date($atime), ")\n";
	print "mtime\t", $mtime, "\t(", &date($mtime), ")\n";
	print "ctime\t", $ctime, "\t(", &date($ctime), ")\n";
	print "blksize\t", $blksize, "\n";
	print "blocks\t", $blocks, "\n";
}

sub date {
	my ($time) = @_;
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
	localtime( $time );
	sprintf("%04d-%02d-%02d %2d:%02d:%02d",
		$year + 1900, $mon + 1, $mday, $hour, $min, $sec);
}

