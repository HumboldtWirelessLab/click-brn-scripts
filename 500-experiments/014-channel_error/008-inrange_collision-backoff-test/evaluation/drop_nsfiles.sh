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

. $CONFIGFILE

rm -f $RESULTDIR/backoff.tr.bz2 $RESULTDIR/backoff.nam.bz2 $RESULTDIR/backoff.tr $RESULTDIR/backoff.nam

exit 0
