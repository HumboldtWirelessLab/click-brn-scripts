#!/bin/sh

CHANNEL="1 2 3 4 5 6 7 8 9 10 11"
#"36 40 44 48 52 56 60 64"
#CHANNEL="1 2"

MEASUREMENT_NUM=1

NEXT_RUNMODE=REBOOT

for rep in `seq 10`; do

REPTIME_DAY=`date +"%j"`
REPTIME_DAY_OF_WEEK=`date +"%u"`
REPTIME_HOUR=`date +"%H"`
REPTIME_MINUTE=`date +"%M"`


for p_c in $CHANNEL; do

  if [ ! -e MEASUREMENT_NUM ]; then

    cp monitor.cfg.tmpl monitor.cfg
    echo "CHANNEL=$p_c" >> monitor.cfg

    if [ $p_c -gt 13 ]; then
      cat sender_and_receiver.mes.tmpl | sed "s#DEVPARAMS#DEV1#g" > sender_and_receiver.mes
      USEDDEV="1"
    else
      cat sender_and_receiver.mes.tmpl | sed "s#DEVPARAMS#DEV0#g" > sender_and_receiver.mes
      USEDDEV="0"
    fi

    #TESTONLY=1 RUNMODE=REBOOT run_measurement.sh sender_and_receiver.des $MEASUREMENT_NUM
    RUNMODE=$NEXT_RUNMODE run_measurement.sh sender_and_receiver.des $MEASUREMENT_NUM

    NEXT_RUNMODE=DRIVER

    if [ -e $MEASUREMENT_NUM ]; then
      echo "CHANNEL=$p_c" > $MEASUREMENT_NUM/params
      echo "DEV=$USEDDEV" >> $MEASUREMENT_NUM/params
      echo "NUM=$MEASUREMENT_NUM" >> $MEASUREMENT_NUM/params
      echo "REP=$rep" >> $MEASUREMENT_NUM/params
      echo "REPTIME_DAY=$REPTIME_DAY" >> $MEASUREMENT_NUM/params
      echo "REPTIME_HOUR=$REPTIME_HOUR" >> $MEASUREMENT_NUM/params
      echo "REPTIME_MINUTE=$REPTIME_MINUTE" >> $MEASUREMENT_NUM/params
      echo "REPTIME_DAY_OF_WEEK=$REPTIME_DAY_OF_WEEK" >> $MEASUREMENT_NUM/params
    fi

    MEASUREMENT_NUM=`expr $MEASUREMENT_NUM + 1`

    if [ -f finish ]; then
      exit 0;
    fi

    rm -f sender_and_receiver.mes monitor.cfg
  fi

done
done