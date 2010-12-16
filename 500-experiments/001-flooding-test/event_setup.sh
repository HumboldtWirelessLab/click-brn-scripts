#!/bin/sh

NODES=`cat $1 | grep -v "#" | uniq`

TIME=$2

if [ "x$MODE" = "x" ]; then
  MODE=EVENT_LINKTABLE
fi


if [ "$MODE" != "EVENT_LINKTABLE" ]; then

  for n1 in $NODES; do
    if [ "x$MODE" = "xSIMPLEFLOW" ]; then
      echo "$TIME $n1 ath0 write sf add_flow $n1:eth ff:ff:ff:ff:ff:ff 470 100 0 50 true"
      TIME=`expr $TIME + 5`
      echo "$TIME $n1 ath0 write sf add_flow $n1:eth ff:ff:ff:ff:ff:ff 470 100 0 50 false"
      TIME=`expr $TIME + 1`
    else    
      for s in `seq 1 1`; do
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

else

  for n1 in $NODES; do
    for n2 in $NODES; do
      echo "$TIME $n2 ath0 read device_wifi/link_stat bcast_stats flooding_stats.$n1" 
    done
    
    TIME=`expr $TIME + 3`
    echo "$TIME $n1 ath0 write event_notifier payload_size 192"

    for s in `seq 1 1`; do
      echo "$TIME $n1 ath0 write event_notifier event now"
      TIME=`expr $TIME + 1`
    done

    TIME=`expr $TIME + 4`
    for n2 in $NODES; do
        echo "$TIME $n2 ath0 read eh stats flooding_stats.$n1"
        echo "$TIME $n2 ath0 write eh reset true"
        echo "$TIME $n2 ath0 read flooding/fl stats flooding_stats.$n1"	
        echo "$TIME $n2 ath0 write flooding/fl reset true"
        echo "$TIME $n2 ath0 read sys_info systeminfo flooding_stats.$n1"	
        echo "$TIME $n2 ath0 read device_wifi/wifidevice/cst stats_xml flooding_stats.$n1"	
    done
    TIME=`expr $TIME + 5`
  done

fi
