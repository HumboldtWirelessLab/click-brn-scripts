#!/bin/bash

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

if [ ! -e $EVALUATIONSDIR ]; then
  mkdir -p $EVALUATIONSDIR
fi

if [ -f $RESULTDIR/measurement.xml ]; then
  DATAFILE=$RESULTDIR/measurement.xml
else
  if [ -f $EVALUATIONSDIR/measurement.xml ]; then
    DATAFILE=$EVALUATIONSDIR/measurement.xml
  else
    DATAFILE=$RESULTDIR/measurement.log
  fi
fi

xsltproc $DIR/tx.xslt $DATAFILE > $EVALUATIONSDIR/tx.info

TX1=`cat $EVALUATIONSDIR/tx.info | head -n 1 | awk '{print $2}'`
TX2=`cat $EVALUATIONSDIR/tx.info | tail -n 1 | awk '{print $2}'`

echo "TX: $TX1 TX2: $TX2"

if [ $TX1 -gt 95 ] && [ $TX2 -gt 95 ]; then
  exit 0;
fi

exit 1
