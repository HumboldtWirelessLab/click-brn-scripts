#!/bin/sh

SEND_PACKETS=`cat $RESULTDIR/measurement.log | grep "mgmt beacon 00-00-00-00-00-01 brn chan 5" | wc -l`

echo -n "Send $SEND_PACKETS beacons."

if [ $SEND_PACKETS -gt 250 ]; then
  echo " OK !"
  exit 0
else
  echo " Too bad !"
  exit 2
fi
