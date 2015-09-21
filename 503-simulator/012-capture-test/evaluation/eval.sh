#!/bin/sh

. $CONFIGFILE
. $RESULTDIR/../config

COL=`cat $RESULTDIR/receiver.tr | grep COL | wc -l`

echo "col $COL"
echo "COL=$COL" > $RESULTDIR/result

echo "$VAR_POWER $COL 0 0" > $RESULTDIR/result.dat
fromdump.sh $RESULTDIR/node2.eth0.raw.dump | sed -e "s#[+/]# #g" | awk -v S=$VAR_POWER -v C=$COL '{print S" "C" "$6" "$12}' | sed -e "s#00-00-00-00-00-0##g" >> $RESULTDIR/result.dat

exit 0