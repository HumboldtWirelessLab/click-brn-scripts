#!/bin/sh

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR="."
fi

MES_FILE=`(cd $RESULTDIR; ls txpower.mes.*)`

RECEIVER=`( cd $RESULTDIR; cat $MES_FILE | grep -v "#" | grep "receiver" | awk '{print $1}')`
SENDER=`( cd $RESULTDIR; cat $MES_FILE | grep -v "#" | grep -v "$RECEIVER" | awk '{print $1}')`

echo "$SENDER $RECEIVER"

NODENUM=1

DATA_MAT="txpower_data.mat"

SENDERMAC=`(cd $RESULTDIR; cat nodes.mac | grep $SENDER | awk '{print $3}' | sed "s#:#-#g")`

echo $SENDERMAC

(cd $RESULTDIR; fromdump.sh $RECEIVER.ath0.dump) | grep "$SENDERMAC" | sed "s#/# #g" | awk '{print $6}' | sed "s#+##g" > $RESULTDIR/$DATA_MAT
#(cd $RESULTDIR; fromdump.sh $RECEIVER.ath0.dump)