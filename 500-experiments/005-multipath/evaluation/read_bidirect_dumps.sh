#!/bin/sh

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR=$1
fi

DUMPS=`(cd $RESULTDIR; ls *.dump)`


if [ "x$WANTEDNODE" = "x" ]; then
  WANTED=0
else
  if [ "x$WANTEDDEVICE" = "x" ]; then
    WANTED=0
  else
    WANTED=1
  fi
fi

SEDARG=""
GREPARG=""
WANTEDMAC=""

while read line; do
  NODE=`echo $line | awk '{print $1}'`
  DEVICE=`echo $line | awk '{print $2}'`
  MAC=`echo $line | awk '{print $3}'`
  ID=`echo $line | awk '{print $4}'`

  if [ "x$GREPARG" = "x" ]; then
    GREPARG="$MAC"
  else
    GREPARG="$GREPARG|$MAC"
  fi

  SEDARG="$SEDARG -e s#$MAC#$ID#g"

  if [ "x$WANTED" = "x1" ]; then
    if [ "x$NODE" = "x$WANTEDNODE" ] && [ "x$DEVICE" = "x$WANTEDDEVICE" ]; then
      WANTEDMAC="$MAC"
    fi
  fi

done < $RESULTDIR/nodes.mac

DATA_MAT="txpower_data.mat"

echo "---------------------------------------------------------------------------------"
echo "Grep: $GREPARG"
echo "Sed: $SEDARG"
echo "Wanted: $WANTED"
echo "Wanted MAC: $WANTEDMAC"


echo -n "" > $RESULTDIR/$DATA_MAT

for i in $DUMPS; do
  NODE=`echo $i | sed "s#\.# #g" | awk '{print $1}'`
  DEVICE=`echo $i | sed "s#\.# #g" | awk '{print $2}'`
  MAC=`cat $RESULTDIR/nodes.mac | grep $NODE | grep $DEVICE | awk '{print $3}'`

  echo -n "$NODE $DEVICE $MAC : "

  if [ "$WANTED" = "0" ]; then
    (cd $RESULTDIR; fromdump.sh $i) | grep "FF-FF-FF-FF-FF-FF" | egrep "$GREPARG" | grep "OKPacket" | sed "s#/# #g" | awk -v DST=$MAC '{print $6" "$7" "$12" "DST}' | sed "s#+##g" | sed $SEDARG >> $RESULTDIR/$DATA_MAT
  else
    if [ "x$NODE" = "x$WANTEDNODE" ] && [ "x$DEVICE" = "x$WANTEDDEVICE" ]; then
      echo "full"
      (cd $RESULTDIR; fromdump.sh $i) | grep "FF-FF-FF-FF-FF-FF" | egrep "$GREPARG" | grep "OKPacket" | sed "s#/# #g" | awk -v DST=$MAC '{print $6" "$7" "$12" "DST}' | sed "s#+##g" | sed $SEDARG >> $RESULTDIR/$DATA_MAT
    else
      echo "small"
      (cd $RESULTDIR; fromdump.sh $i) | grep "FF-FF-FF-FF-FF-FF" | egrep "$WANTEDMAC" | grep "OKPacket" | sed "s#/# #g" | awk -v DST=$MAC '{print $6" "$7" "$12" "DST}' | sed "s#+##g" | sed $SEDARG >> $RESULTDIR/$DATA_MAT
    fi
  fi
done
