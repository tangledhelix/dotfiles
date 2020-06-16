#!/bin/ksh
#############################################################
#
# Looking for a file with a certain pattern? But you can't
# remember where the file is, but know its somewhere in or 
# below the current directory.  This is for you.
#
# You do not give filenames as the setup is to look at all
# files in the cwd, or look in cwd and all subdirectories.
# 
# If you want only to look at files in the current directory
# and not any subdirectories DON'T use the -R option.
# DEFAULT is to do only files in the current directory.
#
# Should be able to use all grep capabilities.
#
# SYNTAX:
#   grepr [-R] [arguments_for_grep] pattern
#
#   The -R tells it to go recursively, else it will 
#   look only at files in the current directory.
#
# EXAMPLES:
#   grepr -R -b pattern
#   grepr -R pattern
#   grepr -v pattern
#   grepr -vb pattern
#
# OTHER POSSIBILITIES:
#   EXAMPLES from the command line:
#
#	### Won't do binary and other data type files, just text.
# 	alias grepr 'grep \!* `find . -type f -print`'
#
#	### To do binary and other data type files
#	### but does have problems with control characters
#	### Maybe pipe to 'tr -d '\xx''.  (Limited help.)
# 	alias egrepr 'egrep \!* `find . -type f -print`'
#
# LIMITATION:
#    Does not look at ALL non-text files (ONLY looks at 
#    FrameMaker, PDF, Microsoft, and compiled C code data 
#    formats (binary), graphics, and compressed files).
#
#    Does not look at 'dot' files (.login for example) as
#    only an 'ls' is done.
#
# BUGS:
#    It does runs VERY slowly - intensive for the filesystem.
#
#  Written by: Matt Baker
#  Created on: 17 Jun 93
#  Last edited on: 27 Aug 2008
#  Version 3.3
#
#  Tested on following:
#  CPU: Sun 3, Sparc, DECstation 5000, Alpha and many others
#  OS: SunOS 4.1.1, Ultrix 4.1, OSF 3.2, Solaris 2.X and many others
#
#############################################################

###################
# Check to see if at least one command line argument (pattern)
###################
if [ $# -lt 1 ]
then
	echo "Usage: $0 [-R] {grep_options} pattern"
	exit 1
fi

###################
# set recursion var and shift so its
# not part of the options (resulting
# in incorrect grep option)
###################
if [ "$1" = "-R" ]
then
	RECURSION="$1"
	shift
else
	RECURSION=""
fi

###################
# Make sure no filenames are given
###################
#for OPT in "$@"
#do
	#if [ -f "$OPT" -o -d "$OPT" ]
	#then
		#echo "*** ERROR: No filenames are allowed ***"
		#echo "Usage: $0 [-R] {grep_options} pattern"
		#exit 1
	#fi
#done

#########################
# Declare function 'lookup'
#########################

###################
#  ORDER OF EVENTS
# Get current pwd ls of files
# IF:      [directory] and -R => call function and repeat (recursive)
# ELSE IF: if [binary,data,framemaker,graphics] => strings | grep
# ELSE IF: if [compress] => zcat | grep
# ELSE:    (plain file) grep
###################

lookup () {
	# get rid of . and .. from list
	for FILE in $(ls -a | egrep -wv '\.|\.\.')
	do
		################
		# for data/binary test
		################
		FILE_TYPE=$(file "$FILE" | awk -F: '{print $2}')

		################
		# if directory, recursion, if not set
		################
		if [ -d $FILE -a -n "$RECURSION" ]
		then
			cd $FILE > /dev/null 2>&1
			lookup "$@"
			cd ..
		################
		# FrameMaker, SunOS compiled code, graphics, OSF compiled code
		# added PDF, Microsoft
		################
		elif [[ -n $(echo $FILE_TYPE | egrep -we \
				'executable|Frame|Microsoft|PDF|rasterfile|data|demand' ) ]]
		then
			OUTPUT="$(strings "$FILE" | grep "$@")"
			if [[ -n $OUTPUT ]]
			then
				echo "$(pwd)/$FILE:"
				echo $OUTPUT
				echo ""
			fi
		################
		# compressed
		################
		elif [ "$(echo $FILE_TYPE | awk '{print $2}')" = "compressed" ]
		then
			OUTPUT="$(zcat $FILE | grep "$@")"
			if [[ -n $OUTPUT ]]
			then
				echo "$(pwd)/$FILE:"
				echo $OUTPUT
				echo ""
			fi
		################
		# normal text file
		################
		else
			OUTPUT="$(grep "$@" $FILE)"
			if [[ -n $OUTPUT ]]
			then
				echo "$(pwd)/$FILE:"
				echo $OUTPUT
				echo ""
			fi
		fi
	done
}

#####################
# Call function
#####################
lookup "$@"

#####################
# Remove temp file
#####################
if [ -s /tmp/$$ ]
then
	rm /tmp/$$
fi




##############################################################################
### This script is submitted to BigAdmin by a user of the BigAdmin community.
### Sun Microsystems, Inc. is not responsible for the
### contents or the code enclosed. 
###
###
### Copyright 2008 Sun Microsystems, Inc. ALL RIGHTS RESERVED
### Use of this software is authorized pursuant to the
### terms of the license found at
### http://www.sun.com/bigadmin/common/berkeley_license.html
##############################################################################


