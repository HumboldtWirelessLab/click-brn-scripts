#!/bin/sh

PACKETSIZE="68"
INTERVAL="100"
PACKETCOUNT="60000"
RUNTIME="6100"
#PACKETCOUNT="6000"
#RUNTIME="610"

#CHANNEL="6 153"
CHANNEL="6 44 153"
POWER_DEC="0 5 10 15"
#POWER_DEC=`seq 0 29`

CURRENT_RUNMODE=REBOOT

MEASUREMENT_NUM=1

for p_c in $CHANNEL; do

  for p_pd in $POWER_DEC; do

    if [ ! -e $MEASUREMENT_NUM ]; then

      cat sender_and_receiver.des.tmpl | sed -e "s#PARAMS_TIME#$RUNTIME#g" > sender_and_receiver.des

      if [ $p_c -lt 15 ]; then
        POWER=`expr 27 - $p_pd`
        cat monitor.802.tmpl |  sed -e "s#PARAMS_CHANNEL#6#g" -e "s#PARAMS_POWER#$POWER#g" > monitor.802
        cat sender_and_receiver.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan0#g" > sender_and_receiver.mes
        cat probe_dump.click.tmpl | sed -e "s#PARAMS_B_ELEMENT#wifioutq#g" -e "s#PARAMS_PACKETSIZE#$PACKETSIZE#g" -e "s#PARAMS_INTERVAL#$INTERVAL#g" -e "s#PARAMS_PACKETCOUNT#$PACKETCOUNT#g" > probe_dump.click
      else
        POWER=`expr 30 - $p_pd`
        cat monitor.802.tmpl |  sed -e "s#PARAMS_CHANNEL#153#g" -e "s#PARAMS_POWER#$POWER#g" > monitor.802
        cat sender_and_receiver.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan1#g" > sender_and_receiver.mes
        cat probe_dump.click.tmpl | sed -e "s#PARAMS_B_ELEMENT#Discard#g" -e "s#PARAMS_PACKETSIZE#$PACKETSIZE#g" -e "s#PARAMS_INTERVAL#$INTERVAL#g" -e "s#PARAMS_PACKETCOUNT#$PACKETCOUNT#g" > probe_dump.click
      fi

      if [ $POWER -ge 0 ]; then

        RUNMODE=$CURRENT_RUNMODE run_measurement.sh sender_and_receiver.des $MEASUREMENT_NUM

        echo "PARAMS_CHANNEL=$p_c" > $MEASUREMENT_NUM/params
        echo "PARAMS_POWER_DEC=$p_pd" >> $MEASUREMENT_NUM/params
        echo "PARAMS_POWER=$POWER" >> $MEASUREMENT_NUM/params
        echo "PARAMS_PACKETSIZE=$PACKETSIZE" >> $MEASUREMENT_NUM/params
        echo "PARAMS_INTERVAL=$INTERVAL" >> $MEASUREMENT_NUM/params
        echo "PARAMS_PACKETCOUNT=$PACKETCOUNT" >> $MEASUREMENT_NUM/params

        MEASUREMENT_NUM=`expr $MEASUREMENT_NUM + 1`

      fi

      rm -f monitor.802 probe_dump.click sender_and_receiver.des sender_and_receiver.mes

      if [ -f finish ]; then
        exit 0;
      fi

    fi

  done

done
