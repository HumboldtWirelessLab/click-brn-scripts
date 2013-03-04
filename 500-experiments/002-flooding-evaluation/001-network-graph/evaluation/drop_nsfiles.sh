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

rm -f $RESULTDIR/*.tr.bz2 $RESULTDIR/*.nam.bz2 $RESULTDIR/*.tr $RESULTDIR/*.nam

exit 0
