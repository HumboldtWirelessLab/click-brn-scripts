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
POSITIONS=`seq 1 40`
#POSITIONS="none"

NUM=1

#SENDER=wgt76
SENDER=wgt81
RECEIVER=wgt79


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

ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"

for p in $POSITIONS; do
  for c in $CHANNELS; do
    #for m in modoptions.default modoptions.default.395; do
    for m in modoptions.default; do

      cat ./tmpl/mode.monitor | sed "s#VAR_CHANNEL#$c#g" | sed "s#VAR_MODOPTIONS#$m#g" > ./mode.monitor

      for r in `seq 1 1`; do

        FINALPATH=$NUM\_channel_$c\_modoption_$m\_monitor

        if [ "$p" != "none" ]; then
          FINALPATH=$FINALPATH\_position_$p
        fi

        RUNMODE=REBOOT run_measurement.sh rxpower.des $FINALPATH

        #echo "$FINALPATH"

        NUM=`expr $NUM + 1`

        if [ "$p" != "none" ]; then
          ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"
        fi

      done
    done
  done

  if [ "$p" != "none" ]; then
    ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/motor.sh forward 100000"
  fi

  sleep 1;

  if [ "$p" != "none" ]; then
     ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 3"
  fi

done

mv ./rxpower.mes.save ./rxpower.mes
mv ./mode.adhoc.save ./mode.adhoc
mv ./mode.monitor.save ./mode.monitor

exit 0
