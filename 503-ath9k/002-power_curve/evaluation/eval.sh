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

if [ "x$RESULTDIR" = "x" ]; then
  if [ "x$1" = "x" ]; then
    RESULTDIR=$DIR/../
  else
    RESULTDIR=$1
    SIGN=`echo $RESULTDIR | cut -b 1`

    case "$SIGN" in
      "/")
         ;;
       *)
         RESULTDIR="$PWD/$RESULTDIR"
         ;;
    esac
  fi
fi

function mac_to_num() {
  NODEMAC_SEDARG=""

  if [ "x$1" != "x" ]; then
    while read line; do
      NODENAME=`echo $line | awk '{print $1}'`
      NODEMAC=`echo $line | awk '{print $3}'`
      NODENUM=`echo $line | awk '{print $4}'`
      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUM#g -e s#$NODENAME#$NODENUM#g"
    done < $1
  fi

# echo $NODEMAC_SEDARG >&2

  sed $NODEMAC_SEDARG
}

DIRNUM=1

echo "CHANNEL POWER TIME RATE HT RATEINDEX HT40 SGI RSSI NOISE" > $RESULTDIR/result.txt 

while [ -e $RESULTDIR/$DIRNUM ]; do


    SENDER=`cat $RESULTDIR/$DIRNUM/power_curve.mes.real | grep sender.click | awk '{print $1}'`
    RECEIVER=`cat $RESULTDIR/$DIRNUM/power_curve.mes.real | grep receiver.click | awk '{print $1}'`

    DEVICE=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$RECEIVER " | awk '{print $2}'`

    #echo "$RECEIVER $SENDER $DEVICE"

    #rm  $RESULTDIR/$DIRNUM/$RECEIVER.$DEVICE.raw.out
    if [ ! -f $RESULTDIR/$DIRNUM/$RECEIVER.$DEVICE.raw.out ]; then

      if [ -f $RESULTDIR/$DIRNUM/$RECEIVER.$DEVICE.raw.dump ]; then
        ( cd $RESULTDIR/$DIRNUM; WIFI=802 fromdump.sh $RECEIVER.$DEVICE.raw.dump | grep "OKPack" | grep -v "err" | grep data | grep ":[[:space:]]*100" | grep FF-FF-FF-FF-FF-FF | sed -e "s#Mb##g" -e "s#+[0]*##g" -e "s#/# #g" -e "s#:##g" > $RECEIVER.$DEVICE.raw.out )
      else
        echo "Missing Dump for $n $d"
      fi
    fi
    . $RESULTDIR/$DIRNUM/params

    cat $RESULTDIR/$DIRNUM/$RECEIVER.$DEVICE.raw.out | awk -v CHANNEL=$PARAMS_CHANNEL -v POWER=$PARAMS_POWER '{ print CHANNEL" "POWER" "$2" "$5" "$6" "$7" "$8" "$9" "$10" "$11 }' | mac_to_num $RESULTDIR/$DIRNUM/nodes.mac | grep -v "[A-F0-9]-" >> $RESULTDIR/result.txt

    DIRNUM=`expr $DIRNUM + 1`

done

exit 0
