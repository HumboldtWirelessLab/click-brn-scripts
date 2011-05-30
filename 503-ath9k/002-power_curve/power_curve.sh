#!/bin/sh

CHANNEL="6 153"
MAX_POWER="30"

MEASUREMENT_NUM=1

for p_c in $CHANNEL; do

  for p_p in `seq $MAX_POWER`; do

    if [ ! -e MEASUREMENT_NUM ]; then

      if [ $p_c -gt 15 ] || [ $p_p -le 27 ]; then

        cat monitor.cfg.tmpl | sed -e "s#PARAMS_CHANNEL#$p_c#g" -e "s#PARAMS_POWER#$p_p#g" > monitor.cfg

        if [  $p_c -lt 15 ]; then
          cat power_curve.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan0#g" > power_curve.mes
        else
          cat power_curve.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan1#g" > power_curve.mes
        fi

        RUNMODE=ENVIRONMENT run_measurement.sh power_curve.des $MEASUREMENT_NUM

        echo "PARAMS_CHANNEL=$p_c" > $MEASUREMENT_NUM/params
        echo "PARAMS_POWER=$p_p" >> $MEASUREMENT_NUM/params

        MEASUREMENT_NUM=`expr $MEASUREMENT_NUM + 1`

        if [ -f finish ]; then
          exit 0;
        fi
      fi
    fi
  done
done
