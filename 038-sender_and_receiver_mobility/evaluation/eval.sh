#!/bin/sh

START_POS_Y=`cat $RESULTDIR/measurement.log | grep "<gps" | head -n 1 | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`
END_POS_Y=`cat $RESULTDIR/measurement.log | grep "<gps" | tail -n 1 | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`

echo -n "Y-Pos: Start: $START_POS_Y End: $END_POS_Y"

if [ $START_POS_Y -ne $END_POS_Y ]; then
  echo " OK !"
  exit 0
else
  echo " Too bad !"
  exit 2
fi
