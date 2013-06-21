#!/bin/sh

. $CONFIGFILE

RECEIVER=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $1}' | head -n 1`
DEVICE=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $2}' | head -n 1`

if [ -f $RESULTDIR/measurement.log ]; then
  PACKETS=`cat $RESULTDIR/measurement.log | grep "OKPacket" | wc -l`
else
  echo "No logfile"
  PACKETS=0
fi

echo "$PACKETS packets received"

if [ $PACKETS -gt 290 ]; then
  exit 0
else
  exit 2
fi
