#!/bin/sh

AUTH=`cat $RESULTDIR/measurement.log | grep "AuthInfo" | head -n 1 | awk '{print $4}'`
ASSOC=`cat $RESULTDIR/measurement.log | grep "AssocInfo" | head -n 1 | awk '{print $4}'`

echo -n "Auth: $AUTH Assoc: $ASSOC."

if [ "x$AUTH" = "xtrue" ] && [ "x$ASSOC" = "xtrue" ]; then
  echo " OK !"
  exit 0
else
  echo " Failed !"
  exit 2
fi
