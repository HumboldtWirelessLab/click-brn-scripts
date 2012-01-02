#!/bin/sh

PACKETSIZE="18"
INTERVAL="5"
PACKETCOUNT="10000"
RATES="g1 n1 n2 n3 n4 n5 n6 n7 n8"

CHANNEL="1 44"

REPEAT=1

CURRENT_RUNMODE=REBOOT

MEASUREMENT_NUM=1

for p_repeat in `seq $REPEAT`; do

 for p_c in $CHANNEL; do

  for p_node in `cat nodes.all | grep -v "#"`; do

    if [ ! -e $MEASUREMENT_NUM ]; then

      cat nodes.all | grep -v "$p_node" | grep -v "#" > nodes

      RUNTIME=`expr $INTERVAL \* $PACKETCOUNT`
      RUNTIME=`expr $RUNTIME / 800`
      RUNTIME=`expr $RUNTIME + 20`

      cat sender_and_receiver.des.tmpl | sed -e "s#PARAMS_TIME#$RUNTIME#g" > sender_and_receiver.des

      cp  probe_sender.click.tmpl probe_sender.click

      if [ $p_c -lt 15 ]; then
        POWER=27
        cat monitor.802.tmpl |  sed -e "s#PARAMS_CHANNEL#$p_c#g" -e "s#PARAMS_POWER#$POWER#g" > monitor.802
        cat sender_and_receiver.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan0#g" -e "s#SENDERNODE#$p_node#g" > sender_and_receiver.mes
      else
        POWER=30
        cat monitor.802.tmpl |  sed -e "s#PARAMS_CHANNEL#$p_c#g" -e "s#PARAMS_POWER#$POWER#g" > monitor.802
        cat sender_and_receiver.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan1#g" -e "s#SENDERNODE#$p_node#g" > sender_and_receiver.mes
      fi

      #TESTONLY=0 
      RUNMODE=$CURRENT_RUNMODE run_measurement.sh sender_and_receiver.des $MEASUREMENT_NUM
      STATE=$?


      echo "PARAMS_CHANNEL=$p_c" > $MEASUREMENT_NUM/params
      echo "PARAMS_REPEAT=$p_repeat" >> $MEASUREMENT_NUM/params
      echo "PARAMS_INTERVAL=$INTERVAL" >> $MEASUREMENT_NUM/params
      echo "PARAMS_SENDER=$p_node" >> $MEASUREMENT_NUM/params
      echo "PARAMS_PACKETCOUNT=$PACKETCOUNT" >> $MEASUREMENT_NUM/params

      MEASUREMENT_NUM=`expr $MEASUREMENT_NUM + 1`

      rm -f monitor.802 probe_sender.click sender_and_receiver.des sender_and_receiver.mes nodes

      if [ -f finish ]; then
        exit 0;
      fi

      if [ $STATE -ne 0 ]; then
        exit 0;
      fi

      CURRENT_RUNMODE=CLICK
    fi

  done
  CURRENT_RUNMODE=REBOOT
 done
done
