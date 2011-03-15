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

ATH0EXISTS=`/sbin/ifconfig ath0 2> /dev/null | wc -l`

echo -n "" > $DIR/measurement.log

if [ $ATH0EXISTS = 0 ]; then
  echo "NO DEVICE" >> $DIR/measurement.log
  exit 0
else
  echo "DEVICE OK" >> $DIR/measurement.log
fi

while [ true ]; do
  POS=`/home/testbed/helper/host/bin/gps.sh getgpspos`
  VALID=`echo $POS | grep "0.0 0.0 0.0" | wc -l`

  if [ $VALID -ne 0 ]; then
    echo "NO POSITION" >> $DIR/measurement.log
  else
    echo "POSITION: $POS" >> $DIR/measurement.log
  fi
done

