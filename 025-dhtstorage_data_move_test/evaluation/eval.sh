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
							       

REPLIES=`cat $RESULTDIR/measurement.log  | grep "No. Replies:" | grep -v "Avg" | awk '{print $3}' | $DIR/sum.sh`
REQUESTS=`cat $RESULTDIR/measurement.log  | grep "No. Request:" | grep -v "Avg" | awk '{print $3}' | $DIR/sum.sh`
RETRIES=`cat $RESULTDIR/measurement.log  | grep "No. Retries:" | grep -v "Avg" | awk '{print $3}' | $DIR/sum.sh`
TIMEOUT=`cat $RESULTDIR/measurement.log  | grep "No. Timeouts:" | grep -v "Avg" | awk '{print $3}' | $DIR/sum.sh`
EXTIMEOUT=`cat $RESULTDIR/measurement.log  | grep "No. excessive Timeouts:" | grep -v "Avg" | awk '{print $4}' | $DIR/sum.sh`

echo "Replies: $REPLIES Requests: $REQUESTS Retries: $RETRIES Timeouts: $TIMEOUT Exc. Timeouts: $EXTIMEOUT"

EXP_REPLIES=`expr $REQUESTS - 10`

if [ $REPLIES -lt $EXP_REPLIES  ]; then
  echo "Failed"
  exit 2
fi

echo "OK!"

exit 0
