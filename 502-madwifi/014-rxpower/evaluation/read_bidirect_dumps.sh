#!/bin/sh

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR=$1
fi

DUMPS=`(cd $RESULTDIR; ls *.dump)`

SEDARG=""

while read line; do
  MAC=`echo $line | awk '{print $3}'`
  ID=`echo $line | awk '{print $4}'`

  if [ "x$GREPARG" = "x" ]; then
    GREPARG="$MAC"
  else
    GREPARG="$GREPARG|$MAC"
  fi

  SEDARG="$SEDARG -e s#$MAC#$ID#g"

done < $RESULTDIR/nodes.mac

DATA_MAT="txpower_data.mat"

echo "$GREPARG  --  $SEDARG"

echo -n "" > $RESULTDIR/$DATA_MAT

for i in $DUMPS; do
  NODE=`echo $i | sed "s#\.# #g" | awk '{print $1}'`
  DEVICE=`echo $i | sed "s#\.# #g" | awk '{print $2}'`
  MAC=`cat $RESULTDIR/nodes.mac | grep $NODE | grep $DEVICE | awk '{print $3}'`
  (cd $RESULTDIR; fromdump.sh $i) | grep "FF-FF-FF-FF-FF-FF" | egrep "$GREPARG" | grep "OKPacket" | sed "s#/# #g" | awk -v DST=$MAC '{print $6" "$7" "$12" "DST}' | sed "s#+##g" | sed $SEDARG >> $RESULTDIR/$DATA_MAT
done
