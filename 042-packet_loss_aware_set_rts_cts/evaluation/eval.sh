#!/bin/sh

. $CONFIGFILE

if [ -f $RESULTDIR/measurement.log ]; then
  PACKETS=`cat $RESULTDIR/measurement.log | grep "OKPacket" | wc -l`
else
  echo "No Dumpfile"
  PACKETS=0
fi

echo "$PACKETS packets received. Eval not finished."

if [ $PACKETS -gt 10 ]; then
  exit 0
else
  exit 2
fi
