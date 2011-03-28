#!/bin/sh

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
    "/")
	DIR=$dir
	;;
    ".")
	DIR=$pwd/$dir
	;;
    *)
	echo "Error while getting directory"
	exit -1
	;;
esac


CHANNELS="1 2 3 4 5 6 7 8 9 10 11 12 13"
#CHANNELS="100 104 108 112 116 120 124 128 132 136 140"

POSITIONS=`seq 1 150`
#POSITIONS="none"

#MODOPTIONS="modoptions.default modoptions.default.395"
MODOPTIONS="modoptions.germany"

POWER_LEVELS="none"
#POWER_LEVELS="5 10 15 20"

NUM=1

SENDER=group:nodes_2
#SENDER=wgt76
#SENDER=wgt81
RECEIVER=wgt79
#SENDER=sk110
#RECEIVER=sk112
#SENDER=wgt80
#RECEIVER=wgt82

mv ./rxpower.mes ./rxpower.mes.save
mv ./mode.adhoc ./mode.adhoc.save
mv ./mode.monitor ./mode.monitor.save


#ADHOC

#rm -f ./rxpower.mes
#cat ./tmpl/rxpower.mes.adhoc | sed "s#SENDER#$SENDER#g" | sed "s#RECEIVER#$RECEIVER#g" > ./rxpower.mes

#for c in $CHANNELS; do
#  cat ./tmpl/mode.adhoc | sed "s#VAR_CHANNEL#$c#g" > ./mode.adhoc
#  for r in `seq 1 5`; do
#    RUNMODE=REBOOT run_measurement.sh rxpower.des $NUM\_channel_$c\_adhoc
#
#    NUM=`expr $NUM + 1`
#  done
#done


#monitor

rm -f ./rxpower.mes
cat ./tmpl/rxpower.mes.monitor | sed "s#SENDER#$SENDER#g" | sed "s#RECEIVER#$RECEIVER#g" > ./rxpower.mes

MODE=REBOOT
REPEATMODE=DRIVER
#REPEATMODE=REBOOT
#POSITIONREPEATMODE=DRIVER
POSITIONREPEATMODE=REBOOT

if [ "$p" != "none" ]; then
  ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"
fi

MEASUREMENT_COUNT=0

for p in $POSITIONS; do
  for c in $CHANNELS; do
    for pow in $POWER_LEVELS; do
      for m in $MODOPTIONS; do
        for r in `seq 1 1`; do

          FINALPATH=$NUM\_channel_$c\_modoption_$m\_monitor

          if [ "$p" != "none" ]; then
            FINALPATH=$FINALPATH\_position_$p
          fi

          if [ "$pow" != "none" ]; then
            if [ "$p" = "none" ]; then
              FINALPATH=$FINALPATH\_position_0
            fi

            FINALPATH=$FINALPATH\_power_$pow

            POWER=$pow

          else
            POWER=20
          fi

          if [ ! -d $FINALPATH ]; then
            cat ./tmpl/mode.monitor | sed "s#VAR_CHANNEL#$c#g" | sed "s#VAR_MODOPTIONS#$m#g" | sed "s#VAR_POWER#$POWER#g" > ./mode.monitor

            RUNMODE=$MODE run_measurement.sh rxpower.des $FINALPATH
            MODE=$REPEATMODE

            (cd $FINALPATH; wget http://www2.informatik.hu-berlin.de/~sombrutz/pub/labs/webcam.jpeg )

            MEASUREMENT_COUNT=`expr $MEASUREMENT_COUNT + 1`

            if [ "$p" != "none" ]; then
              ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"
            fi
          fi

          NUM=`expr $NUM + 1`

        done
      done
    done
  done

  MODE=$POSITIONREPEATMODE

  if [ $MEASUREMENT_COUNT -gt 0 ]; then
    if [ "$p" != "none" ]; then
      ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/motor.sh forward 75000"
    fi

    sleep 1;

    if [ "$p" != "none" ]; then
      ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 3"
    fi
  fi

done

mv ./rxpower.mes.save ./rxpower.mes
mv ./mode.adhoc.save ./mode.adhoc
mv ./mode.monitor.save ./mode.monitor

exit 0
