#!/bin/sh

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR=$1
fi

DATA_MAT="txpower_data.mat"

while read line; do
    NODENAME=`echo $line | awk '{print $1}'`
    NODEMAC=`echo $line | awk '{print $3}'`
    NODEID=`echo $line | awk '{print $4}'`

    if [ "x$NODEMAC" != "x4" ]; then
      if [ $NODEID -gt 4 ]; then
        NODEID=`expr $NODEID - 1`
      fi

      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODEID#g"
      NODENAME_SEDARG="$NODENAME_SEDARG -e s#$NODENAME#$NODEID#g"
      MACNAME_SEDARG="$MACNAME_SEDARG -e s#$NODEMAC#$NODENAME#g"
  fi

done < $RESULTDIR/nodes.mac

#echo "$NODEMAC_SEDARG"
#echo "$NODENAME_SEDARG"

echo -n "" > $RESULTDIR/$DATA_MAT
for d in `(cd $RESULTDIR; ls *.dump)`; do
  RECEIVER=`echo $d | sed "s#\.# #g" | awk '{print $1}'`
#  echo "$RECEIVER"
  (cd $RESULTDIR; fromdump.sh $RECEIVER.ath0.dump) | grep "OKP" | grep "52 |  1Mb" | sed "s#/# #g" | awk -v RECEIVER=$RECEIVER '{print $2" "RECEIVER" "$12" "$6" "$7 }' | sed $MACNAME_SEDARG | egrep -v "[0-1A-F][0-1A-F]-" | sed "s#+##g" | sed "s#\.##g" | sed "s#:##g" | sed $NODENAME_SEDARG >> $RESULTDIR/$DATA_MAT

done
