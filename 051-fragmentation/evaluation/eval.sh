#!/bin/sh

. $CONFIGFILE

if [ -f $RESULTDIR/measurement.log ]; then
  PACKETS=`cat $RESULTDIR/measurement.log | grep "OKPacket" | wc -l`
  FRAGMENTS=`cat $RESULTDIR/measurement.log | grep "OKFrag" | wc -l`
else
  echo "No measurement.log"
  PACKETS=0
  FRAGMENTS=0
fi

echo "$PACKETS packets and $FRAGMENTS fragments received"

if [ $FRAGMENTS -gt $PACKETS ]; then
  exit 0
else
  exit 2
fi
