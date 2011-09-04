#!/bin/sh

STABLE_SUCC=`cat $RESULTDIR/measurement.log | grep "Successor:" | awk '{print $4}' | sort -u`

echo -n "Modes: $STABLE_SUCC."

if [ "x$STABLE_SUCC" = "xtrue" ]; then
  echo " OK !"
  exit 0
else
  echo " Failed !"
  exit 2
fi
