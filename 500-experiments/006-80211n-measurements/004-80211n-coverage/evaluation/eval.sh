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

while [ -e $RESULTDIR/$DIRNUM ]; do

  echo "TIME SIZE SRC DST STATE RATE HT RATEINDEX HT40 SGI RSSI NOISE SEQ CTL_RSSI0 CTL_RSS1 EXT_RSSI0 EXT_RSS1" > $RESULTDIR/result_$DIRNUM\.txt 

    NODES=`cat $RESULTDIR/$DIRNUM/nodes.mac | awk '{print $1}'`

    for n in $NODES; do

      DEVICES=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$n " | awk '{print $2}'`

      for d in $DEVICES; do

        #rm $RESULTDIR/$DIRNUM/$n.$d.raw.out
        if [ ! -f $RESULTDIR/$DIRNUM/$n.$d.raw.out ]; then

          if [ -f $RESULTDIR/$DIRNUM/$n.$d.raw.dump ]; then
            ( cd $RESULTDIR/$DIRNUM; HT=true EVM=true RX=true WIFI=802 fromdump.sh $n.$d.raw.dump | grep -v "TXFeedback" | grep data | grep ":[[:space:]]*100[[:space:]]*|" | grep FF-FF-FF-FF-FF-FF | sed -e "s#Mb##g" -e "s#+[0]*##g" -e "s#/# #g" -e "s#:##g" > $n.$d.raw.out )
          else
            echo "Missing Dump for $n $d"
          fi
        fi

        cat $RESULTDIR/$DIRNUM/$n.$d.raw.out | awk -v NODE=$n '{ print $2" "$3" "$27" "NODE" "$1" "$5" "$6" "$7" "$8" "$9" "$21" "$22" "$30" "$10" "$11" "$13" "$14 }' | sed "s#OKPacket#1#g" | sed "s#CRCerror#0#g" | mac_to_num $RESULTDIR/$DIRNUM/nodes.mac | grep -v "[A-F0-9]-" >> $RESULTDIR/result_$DIRNUM\.txt


      done
    done

    if [ -f $RESULTDIR/$DIRNUM/params ]; then
      . $RESULTDIR/$DIRNUM/params

      mv $RESULTDIR/result_$DIRNUM\.txt $RESULTDIR/result_$PARAMS_CHANNEL\_$PARAMS_POWER\.txt
    fi

  DIRNUM=`expr $DIRNUM + 1`

done

exit 0
