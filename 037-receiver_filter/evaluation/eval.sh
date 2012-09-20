#!/bin/sh

. $CONFIGFILE

RECEIVER=`cat $NODETABLE | grep receiver.click | awk '{print $1}'`
DEVICE=`cat $NODETABLE | grep receiver.click | awk '{print $2}'`

#ls -lisa $RESULTDIR/$RECEIVER.$DEVICE.raw.dump
#echo "$RESULTDIR/$RECEIVER.$DEVICE.raw.dump"

SENDER_1=`cat $NODETABLE | grep "sender_1.click" | awk '{print $1}'`
SENDER_2=`cat $NODETABLE | grep "sender_2.click" | awk '{print $1}'`

MAC_1=`cat $RESULTDIR/nodes.mac | grep -e "^$SENDER_1 " | awk '{print $3}' | sed "s#:#-#g"`
MAC_2=`cat $RESULTDIR/nodes.mac | grep -e "^$SENDER_2 " | awk '{print $3}' | sed "s#:#-#g"`

echo "Sender: $SENDER_1 $SENDER_2 $MAC_1 $MAC_2"

#echo "$RESULTDIR/$RECEIVER.$DEVICE.raw.dump"

PACKETS=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "OKPacket" | wc -l`
PACKETS_1=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "OKPacket" | grep $MAC_1 | wc -l`
PACKETS_2=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "OKPacket" | grep $MAC_2 | wc -l`

echo "$PACKETS packets received. Sender 1: $PACKETS_1 Sender_2: $PACKETS_2"

if [ $PACKETS -gt 100 ]; then
  exit 0
else
  exit 2
fi
