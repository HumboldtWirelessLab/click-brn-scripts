#!/bin/sh

. $CONFIGFILE

RECEIVER=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $1}' | head -n 1`
DEVICE=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $2}' | head -n 1`

#ls -lisa $RESULTDIR/$RECEIVER.$DEVICE.raw.dump
#echo "$RESULTDIR/$RECEIVER.$DEVICE.raw.dump"

if [ -f $RESULTDIR/$RECEIVER.$DEVICE.raw.dump ]; then
  PACKETS=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "OKPacket" | wc -l`
else
  echo "No Dumpfile"
  PACKETS=0
fi

echo "$PACKETS packets received"

if [ $PACKETS -gt 290 ]; then
  exit 0
else
  exit 2
fi
