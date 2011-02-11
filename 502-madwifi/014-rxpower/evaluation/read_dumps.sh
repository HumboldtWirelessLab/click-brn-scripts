#!/bin/sh

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR="."
fi

MES_FILE=`(cd $RESULTDIR; ls rxpower.mes.*)`

RECEIVER=`( cd $RESULTDIR; cat $MES_FILE | grep -v "#" | grep "receiver" | awk '{print $1}')`
ADHOC=0
if [ "x$RECEIVER" = "x" ]; then
  ADHOC=1
  RECEIVER=`( cd $RESULTDIR; cat $MES_FILE | grep -v "#" | grep "rssi" | awk '{print $1}')`
fi

SENDER=`( cd $RESULTDIR; cat $MES_FILE | grep -v "#" | grep -v "$RECEIVER" | awk '{print $1}')`

echo "$SENDER $RECEIVER"

NODENUM=1

DATA_MAT="txpower_data.mat"

SENDERMAC=`(cd $RESULTDIR; cat nodes.mac | grep $SENDER | awk '{print $3}' | sed "s#:#-#g")`

echo $SENDERMAC

if [ $ADHOC -eq 0 ]; then
  (cd $RESULTDIR; fromdump.sh $RECEIVER.ath0.dump) | grep "$SENDERMAC" | sed "s#/# #g" | awk '{print $6}' | sed "s#+##g" > $RESULTDIR/$DATA_MAT
else
  (cd $RESULTDIR; cat rssi.values) | sed "s#:#-#g" | tr '[:lower:]' '[:upper:]' | grep "$SENDERMAC" | awk '{print $5}' > $RESULTDIR/$DATA_MAT
fi