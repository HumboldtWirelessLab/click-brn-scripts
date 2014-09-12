#!/bin/sh

. $CONFIGFILE

(cd $RESULTDIR; for i in `seq 2 50`; do let h=\(i-1\)*10; fromdump.sh sk$i.eth0.raw.dump | wc -l | awk -v d=$h '{print d" "$0}'; done ) > $RESULTDIR/rx_result.dat

exit 0
