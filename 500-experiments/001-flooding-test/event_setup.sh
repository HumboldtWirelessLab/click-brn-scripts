#!/bin/sh

NODES=`cat $1 | grep -v "#" | uniq`

TIME=$2

if [ "x$MODE" = "x" ]; then
  MODE=SIMPLEFLOW
fi

for n1 in $NODES; do

  if [ "x$MODE" = "xSIMPLEFLOW" ]; then
    echo "$TIME $n1 ath0 write sf add_flow $n1:eth ff:ff:ff:ff:ff:ff 470 100 0 50 true"
    TIME=`expr $TIME + 5`
    echo "$TIME $n1 ath0 write sf add_flow $n1:eth ff:ff:ff:ff:ff:ff 470 100 0 50 false"
    TIME=`expr $TIME + 1`
  else    
    for s in `seq 1 5`; do
      echo "$TIME $n1 ath0 write event_notifier event now"
      TIME=`expr $TIME + 1`
    done
  fi
done

TIME=`expr $TIME + 5`

for n1 in $NODES; do
  if [ "x$MODE" = "xSIMPLEFLOW" ]; then
    echo "$TIME $n1 ath0 read sf stats"
  else    
    echo "$TIME $n1 ath0 read eh stats"
  fi
done