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

TARGETHOST=localhost

echo "Stop gpsd"
NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "/etc/init.d/gpsd stop" > /dev/null 2>&1
echo "rmmod cdc_acm"
NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "/sbin/rmmod cdc_acm" > /dev/null 2>&1
echo "Please remove GPS-device and press any key"
read n
sleep 5
echo "Please insert GPS-device and press any key"
read n
sleep 2
echo "Start gpsd"
NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "/etc/init.d/gpsd start" > /dev/null 2>&1
