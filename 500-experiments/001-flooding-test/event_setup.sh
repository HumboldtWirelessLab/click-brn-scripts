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
      echo "$TIME $n1 ath0 write device_wifi/data_suppressor active1 false"
      echo "$TIME $n1 ath0 write device_wifi/data_suppressor active0 false"

      echo "$TIME $n1 ath0 write eh reset true"
      echo "$TIME $n1 ath0 write event_notifier reset true"
      echo "$TIME $n1 ath0 write flooding/fl reset true"
      echo "$TIME $n1 ath0 write device_wifi/data_queue reset true"

#     echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op channel 13"
      echo "$TIME $n1 ath0 write device_wifi/wifidevice/sc set_channel ath0 14"
  done

  TIME=`expr $TIME + 30`

  for n1 in $NODES; do
    if [ "x$CHANNEL" != "x" ]; then
#     echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op channel $CHANNEL"
      echo "$TIME $n1 ath0 write device_wifi/wifidevice/sc set_channel ath0 $CHANNEL"
    fi
    if [ "x$RATE" != "x" ]; then
      echo "$TIME $n1 ath0 write device_wifi/data_rate rate $RATE"
    fi
    if [ "x$TXPOWER" != "x" ]; then
      echo "$TIME $n1 ath0 write device_wifi/data_power power $TXPOWER"
    fi

  done

  for n1 in $NODES; do
      echo "$TIME $n1 ath0 write device_wifi/data_suppressor active1 true"
      echo "$TIME $n1 ath0 write device_wifi/data_suppressor active0 true"
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

    TIME=`expr $TIME + 30`

    for n2 in $NODES; do
      echo "$TIME $n2 ath0 write device_wifi/data_suppressor active1 false"
      echo "$TIME $n2 ath0 write device_wifi/data_suppressor active0 false"
      echo "$TIME $n2 ath0 write device_wifi/data_queue reset true"
#      echo "$TIME $n2 ath0 write device_wifi/wifidevice/ath_op channel 13"
      echo "$TIME $n2 ath0 write device_wifi/wifidevice/sc set_channel ath0 14"
    done

    TIME=`expr $TIME + 30`

    for n2 in $NODES; do
      echo "$TIME $n2 ath0 write device_wifi/data_suppressor active0 true"
      echo "$TIME $n2 ath0 write device_wifi/data_suppressor active1 true"
    done

    TIME=`expr $TIME + 30`

    for n2 in $NODES; do
      echo "$TIME $n2 ath0 write device_wifi/data_suppressor active0 false"
      echo "$TIME $n2 ath0 write device_wifi/data_suppressor active1 false"
    done

    for n2 in $NODES; do
        echo "$TIME $n2 ath0 read eh stats flooding_stats.$n1"
        echo "$TIME $n2 ath0 write eh reset true"
        echo "$TIME $n2 ath0 write event_notifier reset true"
        echo "$TIME $n2 ath0 read flooding/fl stats flooding_stats.$n1"
        echo "$TIME $n2 ath0 write flooding/fl reset true"
        echo "$TIME $n2 ath0 read sys_info systeminfo flooding_stats.$n1"
        echo "$TIME $n2 ath0 read device_wifi/wifidevice/cst stats_xml flooding_stats.$n1"
    done

    for n2 in $NODES; do
#     echo "$TIME $n2 ath0 write device_wifi/wifidevice/ath_op channel $CHANNEL"
      echo "$TIME $n2 ath0 write device_wifi/wifidevice/sc set_channel ath0 $CHANNEL"
    done

    for n2 in $NODES; do
      echo "$TIME $n2 ath0 write device_wifi/data_queue reset true"
      echo "$TIME $n2 ath0 write device_wifi/data_suppressor active0 true"
      echo "$TIME $n2 ath0 write device_wifi/data_suppressor active1 true"
    done
    TIME=`expr $TIME + 10`
  done

fi