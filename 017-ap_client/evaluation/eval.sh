#!/bin/sh

AUTH=`cat $RESULTDIR/measurement.log | grep "AuthInfo" | awk '{print $4}'`
ASSOC=`cat $RESULTDIR/measurement.log | grep "AssocInfo" | awk '{print $4}'`

echo -n "Auth: $AUTH Assoc: $ASSOC."

if [ "x$AUTH" = "xtrue" ] && [ "x$ASSOC" = "xtrue" ]; then
  echo " OK !"
  exit 0
else
  echo " Failed !"
  exit 2
fi
