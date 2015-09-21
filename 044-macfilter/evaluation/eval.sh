#!/bin/sh

. $CONFIGFILE


if [ -f $RESULTDIR/measurement.log ]; then
  PACKETS_02=`cat $RESULTDIR/measurement.log | grep "OKPacket" | grep 00-00-02 | wc -l`
  PACKETS_03=`cat $RESULTDIR/measurement.log | grep "OKPacket" | grep 00-00-03 | wc -l`
else
  echo "No logfile"
  PACKETS=0
fi

echo "$PACKETS_02 packets received from 02 and $PACKETS_03 packets received from 03."

if [ $PACKETS_02 -eq 0 ]; then
  exit 0
else
  exit 2
fi
