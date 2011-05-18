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

echo "INDEX DST RETRIES SENDER CHANNEL BANDWIDTH RATEINDEX SGI GF PACKETSIZE MCS DATARATE BURST RXRATE RXPACKETS RXBYTES RXLOAD RXHWBUSY RXHWRX RXHWTX TXLOAD" > $RESULTDIR/result.txt 

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

  for s in $SENDERFILES; do
    SENDER=`echo $s | sed -e "s#\.# #g" | awk '{print $3}'`
    SENDERDEV=`echo $s | sed -e "s#\.# #g" | awk '{print $4}'`
    
    SENDERLOAD=`cat $RESULTDIR/$DIRNUM/$SENDER.$SENDERDEV.log | grep "loadavg" | sed -e "s#=# #g" -e "s#'# #g" | awk '{print $3}'`

    SENDERCOUNT=`expr $SENDERCOUNT + 1`
    SENDERLOADALL=`calc "$SENDERLOADALL + $SENDERLOAD" | awk '{print $1}'`
#    echo $SENDERLOADALL
  done  

  TXLOAD=`calc "round((100 * $SENDERLOADALL) / $SENDERCOUNT) / 100" | awk '{print $1}'`
  
  RECEIVER=`echo $RECEIVERFILES | sed "s#\.# #g" | awk '{print $3}'`
  RECEIVERDEV=`echo $RECEIVERFILES | sed "s#\.# #g" | awk '{print $4}'`
    
    
  RXLOAD=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "loadavg" | sed -e "s#=# #g" -e "s#'# #g" | awk '{print $3}'`

  RXRATE=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep -v "Overflow" | head -n 2 | tail -n 1` 
  RXPACKETS=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep -v "Overflow" | head -n 4 | tail -n 1`
  RXBYTES=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep -v "Overflow" | head -n 6 | tail -n 1`
  RXLOAD=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "loadavg" | sed -e "s#=# #g" -e "s#'# #g" | awk '{print $3}'`
  RXHWBUSY=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $3}'`
  RXHWRX=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $5}'`
  RXHWTX=`cat $RESULTDIR/$DIRNUM/$RECEIVER.$RECEIVERDEV.log | grep "hwbusy" | sed -e "s#=# #g" -e "s#\"# #g" | awk '{print $7}'`
  
  echo " $RXRATE $RXPACKETS $RXBYTES $RXLOAD $RXHWBUSY $RXHWRX $RXHWTX $TXLOAD" >> $RESULTDIR/result.txt
  
  DIRNUM=`expr $DIRNUM + 1`
done

exit 0
