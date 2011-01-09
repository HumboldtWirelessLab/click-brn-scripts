#!/bin/sh

NODES=`cat $1 | grep -v "#" | uniq`

TIME=$2

if [ "x$DURATION" = "x" ]; then
  DURATION=1000
fi


for n1 in $NODES; do
    echo "$TIME $n1 ath0 write device_wifi/data_suppressor active1 false"
    echo "$TIME $n1 ath0 write device_wifi/data_suppressor active0 false"
    echo "$TIME $n1 ath0 write device_wifi/lp_suppressor active0 false"

    echo "$TIME $n1 ath0 write device_wifi/qc_q reset true"

    echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op clear_hw_queues wifi0"
#   echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op channel $RESET_CHANNEL"
#   echo "$TIME $n1 ath0 write device_wifi/wifidevice/sc set_channel ath0 $RESET_CHANNEL"
done

#   TIME=`expr $TIME + 10`

for n1 in $NODES; do
    if [ "x$CHANNEL" != "x" ]; then
#       echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op channel $CHANNEL"
        echo "$TIME $n1 ath0 write device_wifi/wifidevice/sc set_channel ath0 $CHANNEL"
    fi
    if [ "x$RATE" != "x" ]; then
      echo "$TIME $n1 ath0 write device_wifi/data_rate rate $RATE"
    fi
    if [ "x$TXPOWER" != "x" ]; then
      echo "$TIME $n1 ath0 write device_wifi/data_power power $TXPOWER"
    fi

done

#  TIME=`expr $TIME + 10`

for n1 in $NODES; do
    echo "$TIME $n1 ath0 write device_wifi/data_suppressor active1 true"
    echo "$TIME $n1 ath0 write device_wifi/data_suppressor active0 true"
    echo "$TIME $n1 ath0 write device_wifi/lp_suppressor active0 true"
done

if [ "x$CHANNEL" != "x" ]; then
  TIME=`expr $TIME + 100`
else
  TIME=`expr $TIME + 5`
fi

##############################################################################################
#################################### FOR EACH NODE ###########################################
##############################################################################################

for n1 in $NODES; do

    ################################################################################
    ################################## MEASUREMENT #################################
    ################################################################################

    for n2 in $NODES; do
      echo "$TIME $n2 ath0 read device_wifi/link_stat bcast_stats ig_stats.$n1"
    done

    echo "$TIME $n1 ath0 write device_wifi/qc flow_insert 5000 15000 1500 2"

    TIME=`expr $TIME + 10`

    #get system and channel load during measurement
    for n2 in $NODES; do
      echo "$TIME $n2 ath0 read device_wifi/wifidevice/cst stats_xml ig_stats.$n1"
      echo "$TIME $n2 ath0 read sys_info systeminfo ig_stats.$n1"
    done

    TIME=`expr $TIME + 5`


    TIME=`expr $TIME + 1`

    echo "$TIME $n1 ath0 read device_wifi/qc flow_stats ig_stats.$n1"

    ################################################################################
    ##################################### RESET ####################################
    ################################################################################

#    for n2 in $NODES; do
      echo "$TIME $n1 ath0 write device_wifi/qc_q reset true"
      echo "$TIME $n1 ath0 write device_wifi/wifidevice/ath_op clear_hw_queues wifi0"
#     echo "$TIME $n2 ath0 write device_wifi/wifidevice/ath_op channel $RESET_CHANNEL"
#     echo "$TIME $n2 ath0 write device_wifi/wifidevice/sc set_channel ath0 $RESET_CHANNEL"
#    done


    TIME=`expr $TIME + 5`

    ################################################################################
    ################################# END RESET ####################################
    ################################################################################

done
