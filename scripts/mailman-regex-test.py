#!/usr/bin/env python

import sys
import re

if len(sys.argv) < 3:
    print "Usage: %s <test_addr> <regexp>" % (sys.argv[0])
    sys.exit(1)
else:
    print ''

    address = sys.argv[1]
    pattern = sys.argv[2]

    if re.match(pattern, address):
        print address, 'matches'
    else:
        print 'No match for', address

