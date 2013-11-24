#!/bin/sh

. $CONFIGFILE

if [ -f $RESULTDIR/$d/simpleflooding.tr.bz2 ]; then
  COLLISIONEN=`bzcat $RESULTDIR/$d/simpleflooding.tr.bz2 | grep "COL" | wc -l`
  rm $RESULTDIR/$d/simpleflooding.tr.bz2
else
  if [ -f $RESULTDIR/$d/simpleflooding.tr ]; then
    COLLISIONEN=`cat $RESULTDIR/$d/simpleflooding.tr | grep "COL" | wc -l`
    rm $RESULTDIR/$d/simpleflooding.tr
  else
    COLLISIONEN=0
  fi
fi

echo "$COLLISIONEN" > $EVALUATIONSDIR/collisionen

exit 0
