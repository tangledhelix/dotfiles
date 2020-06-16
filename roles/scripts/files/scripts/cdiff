#!/bin/sh

# cdiff.sh - Convenience wrapper for colordiff
#
# Copyright (C) 2003-2009 Ville Skyttä <ville.skytta@iki.fi>
# Based on cdiff version 1.4 by eivind@FreeBSD.org
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

(if [ "$1" != "" ]; then
    while [ "$1" != "" ]; do
        file=`echo "$1" | perl -pe 's|^file:/+|/|i'`
        case "$file" in
            *.bz2)       cat="bzip2 -dcf" ;;
            *.xz|*.lzma) cat="xz -dc"     ;;
            *)           cat="gzip -dcf"  ;;
        esac
        case `echo "$file" | perl -ne 'print lc $_'` in
        http:*|https:*|ftp:*)
            if [ -z "$CDIFF_FETCH" ]; then
                if which curl >/dev/null 2>&1; then
                    CDIFF_FETCH="curl -s"
                elif which wget >/dev/null 2>&1; then
                    CDIFF_FETCH="wget -e timestamping=off -qO -"
                elif which lwp-request >/dev/null 2>&1; then
                    CDIFF_FETCH="lwp-request -m GET"
                elif which lynx >/dev/null 2>&1; then
                    CDIFF_FETCH="lynx -source"
                elif which elinks >/dev/null 2>&1; then
                    CDIFF_FETCH="elinks -source"
                fi
                if [ -z "$CDIFF_FETCH" ]; then
                    echo "Error: no program to fetch from URLs found."
                    exit 1
                fi
            fi
            $CDIFF_FETCH "$file" | $cat
            ;;
        *)
            $cat "$file"
            ;;
        esac
        shift;
    done
else
    cat
fi) | colordiff | less -R
