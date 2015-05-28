#!/bin/sh

. $CONFIGFILE

exit 0

RECEIVER=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $1}' | head -n 1`
DEVICE=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $2}' | head -n 1`

if [ -f $RESULTDIR/measurement.log ]; then
  H=`cat $RESULTDIR/measurement.log | grep "Handle p" | wc -l`
  H2=`cat $RESULTDIR/measurement.log | grep "Handle2 p" | wc -l`
else
  echo "no measurement.log"
  H=0
fi

echo "Handle: $H Handle2: $H2"

if [ $H2 -gt 2 ]; then
  exit 0
else
  exit 2
fi
