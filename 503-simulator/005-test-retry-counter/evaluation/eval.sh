#!/bin/sh

. $CONFIGFILE

RECEIVER=`cat $NODETABLE | grep -v "#" | grep sender.click | awk '{print $1}' | head -n 1`
DEVICE=`cat $NODETABLE | grep -v "#" | grep sender.click | awk '{print $2}' | head -n 1`

#ls -lisa $RESULTDIR/$RECEIVER.$DEVICE.raw.dump
#echo "$RESULTDIR/$RECEIVER.$DEVICE.raw.dump"

if [ -f $RESULTDIR/$RECEIVER.$DEVICE.raw.dump ]; then
  PACKETS=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "TXFeed" | wc -l`
  PACKETS_TRIES=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "TXFeed" | awk '{ sum += $21; sum += 1 } END { print sum }'`
else
  echo "No Dumpfile"
  PACKETS=0
fi

echo "$PACKETS packets feedbacked. $PACKETS_TRIES tries."

if [ $PACKETS -ne $PACKETS_TRIES ]; then
 exit 2
fi

exit 0
