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
POSITIONS="none"
MODOPTIONS="modoptions.germany"

NUM=1

SENDER=wgt80
RECEIVER=wgt82

#monitor

cat ./tmpl/rxpower.mes.monitor | sed "s#SENDER#$SENDER#g" | sed "s#RECEIVER#$RECEIVER#g" > ./rxpower.mes

for p in $POSITIONS; do
  for c in $CHANNELS; do
    for m in $MODOPTIONS; do

      cat ./tmpl/mode.monitor | sed "s#VAR_CHANNEL#$c#g" | sed "s#VAR_MODOPTIONS#$m#g" > ./mode.monitor

      for r in `seq 1 1`; do

        FINALPATH=$NUM\_channel_$c\_modoption_$m\_monitor

        if [ "$p" != "none" ]; then
          FINALPATH=$FINALPATH\_position_$p
        fi

        RUNMODE=REBOOT run_measurement.sh rxpower.des $FINALPATH

        NUM=`expr $NUM + 1`

      done
    done
  done
done

rm -f ./rxpower.mes
rm -f ./mode.monitor

exit 0
