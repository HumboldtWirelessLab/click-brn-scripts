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

if [ "x$1" = "x" ]; then
  echo "Use $0 number"
  exit 0
fi

if [ -e $DIR/$1 ]; then
  echo "Measurement $1 already exists. Please choose other/higher number."
  exit 0
fi

echo "Kill screen"
NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "killall screen" > /dev/null 2>&1
echo "Kill click"
NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "killall click" > /dev/null 2>&1
NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "killall screen" > /dev/null 2>&1

echo "Restart gpsd"
NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "/etc/init.d/gpsd restart" > /dev/null 2>&1

NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "rmmod ath5k" > /dev/null 2>&1

NODELIST=$TARGETHOST $DIR/../../../../helper/host/bin/run_on_nodes.sh "chmod 666 /dev/ttyACM0" > /dev/null 2>&1

echo "Wenn warnung, dann messung mit strg+c abbrechen und ./restart_gps.sh aufrufen und messung erneut starten"

RUNMODE=REBOOT ../../../../helper/measurement/bin/run_measurement.sh receiver.dis $1
