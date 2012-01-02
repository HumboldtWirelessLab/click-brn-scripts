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
  echo "TIME SIZE SRC DST STATE RATE HT RATEINDEX HT40 SGI RSSI NOISE SEQ CTL_RSSI0 CTL_RSS1 EXT_RSSI0 EXT_RSS1 PACKETID REPEAT CHANNEL" > $RESULTDIR/head.txt
fi

while [ -e $RESULTDIR/$DIRNUM ]; do

  echo -n "$DIRNUM:"

  if [ -e $RESULTDIR/$DIRNUM/params ]; then

    NODES=`cat $RESULTDIR/$DIRNUM/nodes.mac | awk '{print $1}'`

    touch $RESULTDIR/result_$DIRNUM\.txt

    NODESMACDIR=1

    . $RESULTDIR/$DIRNUM/params
    if [ $PARAMS_CHANNEL -lt 14 ]; then
      NODESMACDIR=48
    fi
    SENDER_ID=`echo $PARAMS_SENDER | mac_to_num $RESULTDIR/$NODESMACDIR/nodes.mac`

#     echo "$RESULTDIR/allresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt"

     if [ ! -e $RESULTDIR/allresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt ]; then

       for n in $NODES; do

        echo -n " $n"

        SENDER_MAC=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$PARAMS_SENDER " | awk '{print $3}'`
        SENDER_ID=`echo $PARAMS_SENDER | mac_to_num $RESULTDIR/$NODESMACDIR/nodes.mac`

        if [ ! -e $RESULTDIR/allresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt ]; then
 #        echo "TIME SIZE SRC DST STATE RATE HT RATEINDEX HT40 SGI RSSI NOISE SEQ CTL_RSSI0 CTL_RSS1 EXT_RSSI0 EXT_RSS1 PACKETID REPEAT CHANNEL" > $RESULTDIR/allresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt
          touch $RESULTDIR/allresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt
        fi

        DEVICES=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$n " | awk '{print $2}'`

        for d in $DEVICES; do

          #rm -f $RESULTDIR/$DIRNUM/$n.$d.raw.out
          if [ ! -f $RESULTDIR/$DIRNUM/$n.$d.raw.out ]; then

            if [ -f $RESULTDIR/$DIRNUM/$n.$d.raw.dump ]; then
              ( cd $RESULTDIR/$DIRNUM; CONTENT=yes HT=true EVM=true RX=true WIFI=802 $DIR/fromdump.sh $n.$d.raw.dump | grep data | sed "s# err # #g" | sed "s# tx # #g" | sed "s#retries 0##g" | grep FF-FF-FF-FF-FF-FF | grep $SENDER_MAC | sed -e "s#Mb##g" -e "s#+[0]*##g" -e "s#/# #g" -e "s#:##g" > $n.$d.raw.out )
            else
              echo "Missing Dump for $n $d"
            fi
          fi

          cat $RESULTDIR/$DIRNUM/$n.$d.raw.out | awk -v NODE=$n -v REPEAT=$PARAMS_REPEAT -v CHANNEL=$PARAMS_CHANNEL '{ print $2" "$3" "$27" "NODE" "$1" "$5" "$6" "$7" "$8" "$9" "$21" "$22" "$30" "$10" "$11" "$13" "$14" "strtonum("0x"$39)" "REPEAT" "CHANNEL""}' | sed "s#OKPacket#1#g" | sed "s#CRCerror#0#g" | sed "s#TXFeedback#2#g" | mac_to_num $RESULTDIR/$NODESMACDIR/nodes.mac $2 | grep -v "[A-F0-9]-" >> $RESULTDIR/result_$DIRNUM\.txt

        done

       done

       cat $RESULTDIR/result_$DIRNUM\.txt >> $RESULTDIR/allresult_$PARAMS_CHANNEL\_$PARAMS_REPEAT\_$SENDER_ID.txt
       rm $RESULTDIR/result_$DIRNUM\.txt

     fi
    fi

  DIRNUM=`expr $DIRNUM + 1`

  echo ""

done

exit 0
