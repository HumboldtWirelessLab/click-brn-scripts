#!/bin/sh

. $CONFIGFILE

RECEIVER=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $1}' | tail -n 1`
DEVICE=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $2}' | head -n 1`

#ls -lisa $RESULTDIR/$RECEIVER.$DEVICE.raw.dump
#echo "$RESULTDIR/$RECEIVER.$DEVICE.raw.dump"

if [ -f $RESULTDIR/$RECEIVER.$DEVICE.raw.dump ]; then
    ERRORS=0
    PACKETS=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "OKPacket" | grep -v "seq: 65565" | wc -l`
    PACKETS_RETRY=`fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | grep "OKPacket" | grep -v "seq: 65565" | grep retry | wc -l`
    RETRIES_FEEDBACK=`fromdump.sh $RESULTDIR/sk3.eth0.raw.dump | grep "TXFeedback" | sed "s#fail##g" | awk '{ sum += $20; sum += 1 } END { print sum }'`
    echo "$PACKETS $PACKETS_RETRY $RETRIES_FEEDBACK"
    if [ $PACKETS -ne $RETRIES_FEEDBACK ]; then
      let ERRORS=ERRORS+1
    fi
else
  ERRORS=1
  echo "No Dumpfile"
fi

if [ $ERRORS -ne 0 ]; then
  echo "$ERRORS errors."
  exit 2
else
  exit 0
fi

