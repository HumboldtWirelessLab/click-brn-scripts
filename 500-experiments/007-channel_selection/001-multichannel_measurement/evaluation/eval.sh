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

EVALUATIONSDIR="$EVALUATIONSDIR""/network_info"

if [ ! -e $EVALUATIONSDIR ]; then
  mkdir -p $EVALUATIONSDIR
fi

TESTDUMP=`find $RESULTDIR -name *raw.dump  | head -n 1`
#SEARCHSIZE=`fromdump.sh $TESTDUMP  | grep TX | awk '{print $3}' | head -n 1`
SEARCHSIZE=`fromdump.sh $TESTDUMP  | grep "OKPacket:" | grep "00-00-00-00-00-00" | grep "data nods FF-FF-FF-FF-FF-FF" | awk '{print $3}' | head -n 1`

#echo "$TESTDUMP $SEARCHSIZE"

if [ -f $RESULTDIR/params ]; then
  . $RESULTDIR/params

  OUT=$EVALUATIONSDIR/packet_rxstats.txt

  for d in `ls -d $RESULTDIR/*raw.dump`; do
    DUMP="$d"
    NODENAME=`basename $DUMP | sed "s#\.# #g" | awk '{print $1}' | NAME2NUM=1 human_readable.sh $RESULTDIR/nodes.mac`
    fromdump.sh $DUMP | grep "[[:space:]]$SEARCHSIZE |" | grep "OKPacket:" | grep "00-00-00-00-00-00" | grep "data nods FF-FF-FF-FF-FF-FF" | sed -e "s#Mb##g" -e "s#+##" -e "s#/# #g" -e "s#:##g" | awk -v NN=$NODENAME -v ID=$CHANNEL '{print ID" "$2" "$5" "$6" "$7" "$12" "NN" "$15}' | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac >> $OUT
    #echo "$DUMP"
  done
fi


if [ -f $RESULTDIR/80211n_coverage.tr ]; then
  rm -f $RESULTDIR/80211n_coverage.tr
  rm -f $RESULTDIR/80211n_coverage.nam
fi

rm -f $RESULTDIR/*.raw.dump
