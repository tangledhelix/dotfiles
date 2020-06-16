#!/bin/sh
#
# ikorolev
# korolev-ia [at] yandex.ru
# http://unixpin.com
#
# Script show what process hold the network port. 
# Output is in  humanreadable and command line pereprocessor format. 
# Script can select data by port, prosess-id or user-id.
#
# v 1.1 2008.05.23
# 
usage() {
        echo "What process has socket?"
        echo "Usage: $0 { all | port <port_num> | pid <proc_id> | user <username> }"
}

case "$1" in
all)
        pids=`/usr/bin/ps -e -o pid`
	;;
port)
        if [ -z "$2" ]; then
                usage
                exit 1  
        fi
	port="$2$"
        pids=`/usr/bin/ps -e -o pid`
        ;;
pid)
	if [ -z "$2" ]; then
		usage
		exit 1
	fi
	pids="$2"
	;;
user)
        if [ -z "$2" ]; then
                usage
                exit 1  
        fi
	pids=`/usr/bin/ps -o pid -u $2`
	;;
*)
	usage
        exit 1
	;;
esac


printf "SOCK_TYPE\tPROTOCOL\tIP\tPORT\tPID\tUSER\tCOMMAND\n"
        for f in $pids
        do
                PFILES=`/usr/proc/bin/pfiles $f 2>/dev/null`
                if [ $? -ne 0 ] ; then
                        continue
                fi

                /usr/bin/printf "$PFILES" |  /usr/bin/egrep  -e "sockname:.+port: $port"  1>/dev/null 2>&1
                if [ $? -eq 0 ] ; then
			PROC=`/usr/bin/ps -o pid,user,args -p $f | /usr/bin/tail +2` 
			export PROC
			/usr/bin/printf "$PFILES"   |  /usr/bin/nawk '/port:/{ print $1"\t"$2"\t"$3"\t"$5"\t" ENVIRON["PROC"] }' 
                fi
        done

exit 0




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


