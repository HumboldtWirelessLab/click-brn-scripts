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

export PATH=$PATH:/sbin:/usr/sbin/

sleep 5
iwconfig ath0 channel 14
#iwconfig ath0 channel 42
sleep 20
iwconfig ath0 channel 46



