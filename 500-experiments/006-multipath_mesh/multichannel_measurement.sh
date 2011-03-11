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


CHANNELS="1 2 3 4 5 6 7 8 9 10 11 12 13 14"
#CHANNELS="1 14"


NUM=1

rm -f ./mode.monitor

for c in $CHANNELS; do
   cat ./tmpl/mode.monitor | sed "s#VAR_CHANNEL#$c#g" > ./mode.monitor
   for r in `seq 1 1`; do
     RUNMODE=REBOOT run_measurement.sh rxpower_mesh.des $NUM\_channel_$c\_monitor

     NUM=`expr $NUM + 1`
  done
done

rm -f ./mode.monitor

exit 0
