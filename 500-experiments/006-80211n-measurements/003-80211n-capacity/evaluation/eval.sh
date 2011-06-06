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

DIRNUM=1

echo "INDEX DST RETRIES SENDER CHANNEL BANDWIDTH RATEINDEX SGI GF PACKETSIZE MCS DATARATE BURST RXRATE RXPACKETS RXBYTES RXLOAD RXHWBUSY RXHWRX RXHWTX TXLOAD RXPACKET_CST RXCRCP NO_NEIGHBOURS RXRATE_CST RXRATE_10S TXRATE TXRATE_10S" > $RESULTDIR/result.txt 

while [ -e $RESULTDIR/$DIRNUM ]; do

  if [ -f $RESULTDIR/$DIRNUM/params ]; then

    . $RESULTDIR/$DIRNUM/params

    echo -n "$DIRNUM $PARAMS_DST $PARAMS_RETRIES $PARAMS_NO_SENDER $PARAMS_CHANNEL $PARAMS_BANDWIDTH $PARAMS_RATEINDEX " >> $RESULTDIR/result.txt
    echo -n "$PARAMS_SGI $PARAMS_GF $PARAMS_PACKETSIZE $PARAMS_MCS $PARAMS_DATARATE $PARAMS_BURST" >> $RESULTDIR/result.txt
  else
    echo "no params"
  fi


  SENDERFILES=`(cd $RESULTDIR/$DIRNUM; ls sender.click.*)`
  RECEIVERFILES=`(cd $RESULTDIR/$DIRNUM; ls receiver.click.*)`

  SENDERLOADALL="0.0"
  SENDERCOUNT=0
  SENDERTXRATEALL="0.0"
  SENDERTXRATE_10_ALL="0.0"


  for s in $SENDERFILES; do
    SENDER=`echo $s | sed -e "s#\.# #g" | awk '{print $3}'`
    SENDERDEV=`echo $s | sed -e "s#\.# #g" | awk '{print $4}'`


    SENDERLOAD=`cat $RESULTDIR/$DIRNUM/$SENDER.$SENDERDEV.log | grep "cpu_usage" | sed -e "s#=# #g" -e "s#'# #g" -e "s#\"# #g" | awk '{print $3}'`

    SENDERCOUNT=`expr $SENDERCOUNT + 1`
    SENDERLOADALL=`calc "$SENDERLOADALL + $SENDERLOAD" | awk '{print $1}'`

    TXRATE=`cat $RESULTDIR/$DIRNUM/$SENDER.$SENDERDEV.log | grep -v "Overflow" | grep -v "Silence" | grep -v "pull" | head -n 2 | tail -n 1` 
    TXRATE_10=`cat $RESULTDIR/$DIRNUM/$SENDER.$SENDERDEV.log | grep -v "Overflow" | grep -v "Silence" | grep -v "pull" | head -n 6 | tail -n 1` 

    SENDERTXRATEALL=`calc "round($SENDERTXRATEALL + $TXRATE)" | awk '{print $1}'`
    SENDERTXRATE_10_ALL=`calc "round($SENDERTXRATE_10_ALL + $TXRATE_10)" | awk '{print $1}'`
  done


  SENDERTXRATE_10_ALL=`calc "round($SENDERTXRATE_10_ALL * 0.8)" | awk '{print $1}'`
  TXLOAD=`calc "round((100 * $SENDERLOADALL) / $SENDERCOUNT) / 100" | awk '{print $1}'`

  RECEIVER=`echo $RECEIVERFILES | sed "s#\.# #g" | awk '{print $3}'`
  RECEIVERDEV=`echo $RECEIVERFILES | sed "s#\.# #g" | awk '{print $4}'`

  RXLOAD=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "cpu_usage" | sed -e "s#=# #g" -e "s#'# #g" -e "s#\"# #g" | awk '{print $3}'`
  RXRATE=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep -v "Overflow" | grep -v "Silence" | grep -v "pull" | head -n 2 | tail -n 1` 
  RXPACKETS=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep -v "Overflow" | grep -v "Silence" | grep -v "pull" |  head -n 4 | tail -n 1`
  RXBYTES=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep -v "Overflow" | grep -v "Silence" | grep -v "pull" | head -n 6 | tail -n 1`

  RXHWBUSY=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | head -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $3}'`
  RXHWRX=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | head -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $5}'`
  RXHWTX=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | head -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $7}'`

  RXPACKETS=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "<mac packets" | head -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $5}'`
  RXCRCPACKETS=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "<mac packets" | head -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $9}'`
  NO_NEIGHBOURS=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "<mac packets" | head -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $33}'`

  RXBYTES_CST=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "<mac packets" | head -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $23}'`
  RXBYTES_CST_2=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "<mac packets" | tail -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $23}'`

  if [ "x$RXBYTES_CST_2" != "x" ]; then
    if [ $RXBYTES_CST -lt $RXBYTES_CST_2 ]; then
      RXHWBUSY=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | tail -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $3}'`
      RXHWRX=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | tail -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $5}'`
      RXHWTX=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | tail -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $7}'`

      RXPACKETS=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "<mac packets" | tail -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $5}'`
      RXCRCPACKETS=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "<mac packets" | tail -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $9}'`
      NO_NEIGHBOURS=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "<mac packets" | tail -n 1 | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $33}'`

      RXBYTES_CST=$RXBYTES_CST_2
    fi
  fi

  if [ $RXHWBUSY -lt $RXHWRX ]; then
    echo "$DIRNUM has invalid busy"
  fi

  RXRATE_CST=`calc "round($RXBYTES_CST * 8)" | awk '{print $1}'`
  RXRATE_10=`calc "round($RXBYTES * 0.8)" | awk '{print $1}'`

  echo " $RXRATE $RXPACKETS $RXBYTES $RXLOAD $RXHWBUSY $RXHWRX $RXHWTX $TXLOAD $RXPACKETS $RXCRCPACKETS $NO_NEIGHBOURS $RXRATE_CST $RXRATE_10 $SENDERTXRATEALL $SENDERTXRATE_10_ALL" >> $RESULTDIR/result.txt

  DIRNUM=`expr $DIRNUM + 1`
done

exit 0
