#!/bin/sh

NODES=`cat $1 | grep -v "#" | uniq`

TIME=$2

for n1 in $NODES; do
  echo "$TIME $n1 ath0 write device_wifi/lp_suppressor active0 false"
  echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op set_macclone true"
  echo "$TIME $n1 ath0 write flooding/unicfl mac 00:01:02:03:04:05"
  echo "$TIME $n1 ath0 write flooding/unicfl strategy 3"
  echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op mac 00:01:02:03:04:05"
  echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op set_macclone false"
#  echo "$TIME $n1 ath0 write wireless reset_address"
done


for n1 in $NODES; do
    echo "$TIME $n1 ath0 write event_notifier payload_size 192"

    for s in `seq 1 1`; do
      echo "$TIME $n1 ath0 write event_notifier event now"
      TIME=`expr $TIME + 1`
    done
done
