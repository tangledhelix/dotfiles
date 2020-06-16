#!/usr/bin/env bash
#
# Converting my status reports to wikitext format. Ruby does most of
# the work.
#
# * [[User:Dan:Work Logs:2003-11-28|2003-11-28]]
# * [[User:Dan:Work Logs:2003-11-21|2003-11-21]]
# * [[User:Dan:Work Logs:2003-11-14|2003-11-14]]

out="index.txt"
parser="/Users/dan/local/bin/statparser.rb"

mkdir bkup
touch $out

for file in `ls -r 200?-??-??.txt`; do
	echo "Backing up $file"
	cp $file bkup/$file
	echo "Parsing $file"
	$parser < $file > tmpfile
	mv tmpfile $file
	datename="`basename $file .txt`"
	echo "* [[User:Dan:Work Logs:$datename|$datename]]" >> $out
done

