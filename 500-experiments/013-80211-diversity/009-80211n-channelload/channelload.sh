#!/bin/sh

CHANNEL="1 6 11 44 161"

CURRENT_RUNMODE=REBOOT

MEASUREMENT_NUM=1

for p_c in $CHANNEL; do

  cat monitor.802.tmpl | sed -e "s#PARAMS_CHANNEL#$p_c#g" > monitor.802

  if [ $p_c -gt 14 ]; then
    cat channelload.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan1#g" > channelload.mes
  else
    cat channelload.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan0#g" > channelload.mes
  fi

  #TESTONLY=0
  RUNMODE=$CURRENT_RUNMODE run_measurement.sh channelload.des $MEASUREMENT_NUM

  echo "PARAMS_CHANNEL=$p_c" > $MEASUREMENT_NUM/params
  MEASUREMENT_NUM=`expr $MEASUREMENT_NUM + 1`

  CURRENT_RUNMODE=DRIVER

done

rm -f monitor.802 channelload.mes
