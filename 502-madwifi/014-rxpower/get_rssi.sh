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

if [ -e /usr/sbin/wlanconfig ]; then
  WLANCONFIG=/usr/sbin/wlanconfig
else
  if [ -e /sbin/wlanconfig ]; then
    WLANCONFIG=/sbin/wlanconfig
  else
    if [ -e /usr/bin/wlanconfig ]; then
      WLANCONFIG=/usr/bin/wlanconfig
    fi
  fi
fi

CHECKFILE=/tmp/wlan_rssi

case "$1" in
    "start")
      echo "Start RSSI check (loop )"
      rm -rf $CHECKFILE
      touch $CHECKFILE
      while [ -f $CHECKFILE ]; do
        ${WLANCONFIG} ath0 list > $FINALRESULTDIR/rssi.values 2>&1
        sleep 1
      done
      echo "Loop finished"
      ;;
    "stop")
      echo "Stop RSSI check"
      rm -rf $CHECKFILE
      ;;
      *)
      echo "Unknown option: > $1 <"
      ;;
esac

exit 0
