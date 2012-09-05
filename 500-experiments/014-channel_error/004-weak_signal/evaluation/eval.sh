#!/bin/sh

. $CONFIGFILE

RECEIVER=`cat $NODETABLE | grep receiver.click | awk '{print $1}'`
DEVICE=`cat $NODETABLE | grep receiver.click | awk '{print $2}'`

#ls -lisa $RESULTDIR/$RECEIVER.$DEVICE.raw.dump
#echo "$RESULTDIR/$RECEIVER.$DEVICE.raw.dump"

#PACKETS=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "OKPacket" | wc -l`
PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "^r " | wc -l`

echo "$PACKETS packets received"

if [ $PACKETS -gt 290 ]; then
  exit 0
else
  exit 2
fi
