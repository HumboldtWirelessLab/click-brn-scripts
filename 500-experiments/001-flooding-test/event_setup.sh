#!/bin/sh

NODES=`cat $1 | grep -v "#" | uniq`

TIME=$2


if [ "x$MODE" = "x" ]; then
  MODE=EVENT_LINKTABLE
fi

if [ "x$PACKETSIZE" = "x" ]; then
  PACKETSIZE=192
fi

if [ "x$PACKETS" = "x" ]; then
  PACKETS=100
fi

if [ "$MODE" = "EVENT_LINKTABLE" ]; then

  for n1 in $NODES; do
    if [ "x$CHANNEL" != "x" ]; then
      echo "$TIME $n2 ath0 write device_wifi/wifidevice/ath_op channel $CHANNEL"	
    fi
    if [ "x$RATE" != "x" ]; then
      echo "$TIME $n2 ath0 write device_wifi/data_rate rate $RATE" 
    fi
    if [ "x$TXPOWER" != "x" ]; then
      echo "$TIME $n2 ath0 write device_wifi/data_power power $TXPOWER" 
    fi
  done

  if [ "x$CHANNEL" != "x" ]; then
    TIME=`expr $TIME + 100`
  else
    TIME=`expr $TIME + 5`
  fi

  for n1 in $NODES; do
    for n2 in $NODES; do
      echo "$TIME $n2 ath0 read device_wifi/link_stat bcast_stats flooding_stats.$n1" 
    done

    TIME=`expr $TIME + 1`
    echo "$TIME $n1 ath0 write event_notifier payload_size $PACKETSIZE"
    TIME=`expr $TIME + 1`

    for s in `seq 1 $PACKETS`; do
      echo "$TIME $n1 ath0 write event_notifier event now"
      TIME=`expr $TIME + 1`
    done

    TIME=`expr $TIME + 2`
    for n2 in $NODES; do
        echo "$TIME $n2 ath0 read eh stats flooding_stats.$n1"
        echo "$TIME $n2 ath0 write eh reset true"
        echo "$TIME $n2 ath0 write event_notifier reset true"
        echo "$TIME $n2 ath0 read flooding/fl stats flooding_stats.$n1"
        echo "$TIME $n2 ath0 write flooding/fl reset true"
        echo "$TIME $n2 ath0 read sys_info systeminfo flooding_stats.$n1"
        echo "$TIME $n2 ath0 read device_wifi/wifidevice/cst stats_xml flooding_stats.$n1"
        echo "$TIME $n2 ath0 write device_wifi/data_queue reset true"
    done
    TIME=`expr $TIME + 2`
  done

else

  for n1 in $NODES; do
    if [ "x$MODE" = "xSIMPLEFLOW" ]; then
      echo "$TIME $n1 ath0 write sf add_flow $n1:eth ff:ff:ff:ff:ff:ff 470 100 0 50 true"
      TIME=`expr $TIME + 5`
      echo "$TIME $n1 ath0 write sf add_flow $n1:eth ff:ff:ff:ff:ff:ff 470 100 0 50 false"
      TIME=`expr $TIME + 1`
    else    
      for s in `seq 1 $PACKETS`; do
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
fi