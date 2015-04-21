#!/bin/sh

. $CONFIGFILE

GOOD_LINKS=`grep -v " 0$" $EVALUATIONSDIR/network_info/linksmetric.mat  | wc -l`

echo -n "$GOOD_LINKS good links."

if [ $GOOD_LINKS -ge 64 ]; then
  echo " OK !"
  exit 0
else
  echo " Too bad !"
  exit 2
fi
