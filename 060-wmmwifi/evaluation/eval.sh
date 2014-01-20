#!/bin/sh

. $CONFIGFILE

if [ -f $RESULTDIR/measurement.log ]; then
  ACKS=`cat $RESULTDIR/measurement.log | grep " cntl ack " | wc -l`
else
  echo "no measurement.log"
  ACKS=1
fi

echo "ACKS: $ACKS"

if [ $ACKS -gt 0 ]; then
  exit 1
else
  exit 0
fi
