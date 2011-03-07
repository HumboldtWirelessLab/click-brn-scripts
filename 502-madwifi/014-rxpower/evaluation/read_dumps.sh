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
  echo "CLICK"
# (cd $RESULTDIR; WIFITYPE=804 WIFI=804 fromdump.sh $RECEIVER.ath0.dump)
# (cd $RESULTDIR; WIFITYPE=802 WIFI=802 fromdump.sh $RECEIVER.wlan0.dump) | grep "$SENDERMAC $SENDERMAC" | sed "s#/# #g" | awk '{print $6-255-$7" "$7}' | sed "s#+##g" > $RESULTDIR/$DATA_MAT
# (cd $RESULTDIR; fromdump.sh $RECEIVER.ath0.dump) | grep "$SENDERMAC $SENDERMAC" | sed "s#/# #g" | awk '{print $6" "$7}' | sed "s#+##g" > $RESULTDIR/$DATA_MAT
  (cd $RESULTDIR; fromdump.sh $RECEIVER.ath0.dump) | grep "$SENDERMAC" | sed "s#/# #g" | awk '{print $6" "$7}' | sed "s#+##g" > $RESULTDIR/$DATA_MAT
else
  echo "ADHOC"
  SENDERMAC=`echo $SENDERMAC | sed "s#-# #g" | awk '{print $3"-"$4"-"$5"-"$6}'`
  (cd $RESULTDIR; cat rssi.values) | sed "s#:#-#g" | tr '[:lower:]' '[:upper:]' | grep "$SENDERMAC" | awk '{print $5" "$6-$5}' > $RESULTDIR/$DATA_MAT
fi