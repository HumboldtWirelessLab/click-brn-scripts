#!/bin/sh

NODES=`cat $1 | grep -v "#" | uniq`

TIME=$2

for n1 in $NODES; do
  for n2 in $NODES; do
    if [ "$n1" != "$n2" ]; then
      echo "$TIME $n1 ath0 write sf add_flow $n1:eth $n2:eth 1000 100 0 100 true"
      TIME=`expr $TIME + 5`
      echo "$TIME $n1 ath0 read  sf stats"
      echo "$TIME $n1 ath0 write sf add_flow $n1:eth $n2:eth 1000 100 0 100 false"
      TIME=`expr $TIME + 3`
    fi
  done
done