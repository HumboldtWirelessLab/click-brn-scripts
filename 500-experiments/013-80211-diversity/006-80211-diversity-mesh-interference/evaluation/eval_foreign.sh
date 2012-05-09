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
      if [ "x$2" != "x" ]; then
        NODENUM=`cat $2 | grep $NODENAME | awk '{print $2}'`
      fi
      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUM#g -e s#$NODENAME#$NODENUM#g"
    done < $1
  fi

# echo $NODEMAC_SEDARG >&2

  sed $NODEMAC_SEDARG
}

DIRNUM=1

if [ ! -e $RESULTDIR/head.txt ]; then
  echo "TIME SIZE DST STATE RATE HT RATEINDEX HT40 SGI RSSI NOISE" > $RESULTDIR/head.txt
fi

while [ -e $RESULTDIR/$DIRNUM ]; do

  echo -n "$DIRNUM:"

  if [ -e $RESULTDIR/$DIRNUM/params ]; then

    NODES=`cat $RESULTDIR/$DIRNUM/nodes.mac | awk '{print $1}'`

    touch $RESULTDIR/result_$DIRNUM\.txt

    NODESMACDIR=1

    . $RESULTDIR/$DIRNUM/params
    if [ $PARAMS_CHANNEL -lt 14 ]; then
      NODESMACDIR=1
    fi
    SENDER_ID=`echo $PARAMS_SENDER | mac_to_num $RESULTDIR/$NODESMACDIR/nodes.mac`

#     echo "$RESULTDIR/allresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt"

     rm -f $RESULTDIR/allforeignresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt
     if [ ! -e $RESULTDIR/allforeignresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt ]; then

       for n in $NODES; do

        echo -n " $n"

        SENDER_MAC=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$PARAMS_SENDER " | awk '{print $3}'`
        SENDER_ID=`echo $PARAMS_SENDER | mac_to_num $RESULTDIR/$NODESMACDIR/nodes.mac`

        if [ ! -e $RESULTDIR/allforeignresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt ]; then
 #        echo "TIME SIZE SRC DST STATE RATE HT RATEINDEX HT40 SGI RSSI NOISE SEQ CTL_RSSI0 CTL_RSS1 EXT_RSSI0 EXT_RSS1 PACKETID REPEAT CHANNEL" > $RESULTDIR/allresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt
          touch $RESULTDIR/allforeignresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt
        fi

        DEVICES=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$n " | awk '{print $2}'`

        for d in $DEVICES; do

          rm -f $RESULTDIR/$DIRNUM/$n.$d.foreign.raw.out
          if [ ! -f $RESULTDIR/$DIRNUM/$n.$d.foreign.raw.out ]; then

            if [ -f $RESULTDIR/$DIRNUM/$n.$d.raw.dump ]; then
              ( cd $RESULTDIR/$DIRNUM; CONTENT=yes HT=true EVM=true RX=true WIFI=802 $DIR/fromdump.sh $n.$d.raw.dump | grep -v RAW | grep -v expensive | sed "s# err # #g" | sed "s# tx # #g" | sed "s#retries 0##g" | grep -v $SENDER_MAC | sed -e "s#Mb##g" -e "s#+[0]*##g" -e "s#/# #g" -e "s#:##g" > $n.$d.foreign.raw.out )
            else
              echo "Missing Dump for $n $d"
            fi
          fi

          cat $RESULTDIR/$DIRNUM/$n.$d.foreign.raw.out | awk -v NODE=$n -v REPEAT=$PARAMS_REPEAT -v CHANNEL=$PARAMS_CHANNEL '{ print $2" "$3" "NODE" "$1" "$5" "$6" "$7" "$8" "$9" "$21" "$22}' | sed "s#OKPacket#1#g" | sed "s#CRCerror#0#g" | sed "s#TXFeedback#2#g" | mac_to_num $RESULTDIR/$NODESMACDIR/nodes.mac $2  >> $RESULTDIR/result_$DIRNUM\.txt

        done

       done

       cat $RESULTDIR/result_$DIRNUM\.txt >> $RESULTDIR/allforeignresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt
       rm $RESULTDIR/result_$DIRNUM\.txt

     fi
    fi

  DIRNUM=`expr $DIRNUM + 1`

  echo ""

done

exit 0
