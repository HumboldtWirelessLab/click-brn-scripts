#!/bin/sh

NODES=`cat $1 | grep -v "#" | uniq`

TIME=$2

#for n1 in $NODES; do
#  for s in `seq 1 100`; do
#    echo "$TIME $n1 ath0 write event_notifier event now"
#    TIME=`expr $TIME + 1`
#  done
#done

#TIME=`expr $TIME + 5`

for n1 in $NODES; do
    echo "$TIME $n1 ath0 read eh stats"
done