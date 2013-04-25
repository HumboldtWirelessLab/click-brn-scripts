#!/bin/sh

if [ "x$1" = "x" ]; then
  ALLRESDIR=.
else
  ALLRESDIR=$1
fi

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

DIRNUM=1

echo "NUM,NO_NODES,PACKETSIZE,BACKOFF_MAX,BACKOFF,SEED,RATE,TIME,NODE,ID,PHY_HWBUSY,PHY_HWRX,PHY_HWTX,RXPKT,CRCPKT,PHYPKT,ADDR,RSSI,STDRSSI,MINRSSI,MAXRSSI,PKTCNT,RXRETRIES,TXRETRIES,MAC_BUSY,MAC_RX,MAX_TX,MISSED_SEQ,CHANNEL,TARGET,CHANNELMODEL,TQM" > inrange.mat.tmp
echo "NUM,NO_NODES,PACKETSIZE,BACKOFF,BACKOFF_MAX,SEED,RATE,PACKETCOUNT,TARGET,CHANNELMODEL,TQM" > inrange_cnt.mat.tmp
echo "NUM,NO_NODES,PACKETSIZE,BACKOFF,BACKOFF_MAX,SEED,RATE,BYTECOUNT,TARGET,CHANNELMODEL,TQM" > inrange_byte_cnt.mat.tmp

MAX_NO_NODES=0
MAX_NO_NODES_DIR=0

while [ -e $ALLRESDIR/$DIRNUM ]; do

  if [ -f $ALLRESDIR/$DIRNUM/params ]; then
    . $ALLRESDIR/$DIRNUM/params

    if [ -f $ALLRESDIR/$DIRNUM/measurement.log.bz2 ]; then
      bzip2 -d $ALLRESDIR/$DIRNUM/measurement.log.bz2
    fi

    if [ -f $ALLRESDIR/$DIRNUM/sender_and_receiver.des.real ]; then
      CONFIGFILE=$ALLRESDIR/$DIRNUM/sender_and_receiver.des.real RESULTDIR=$ALLRESDIR/$DIRNUM $DIR/eval.sh
    else
      CONFIGFILE=$ALLRESDIR/$DIRNUM/sender_and_receiver.des.ns2 RESULTDIR=$ALLRESDIR/$DIRNUM $DIR/eval.sh
    fi

    cat $ALLRESDIR/$DIRNUM/receiver_info.mat >> inrange.mat.tmp
    cat $ALLRESDIR/$DIRNUM/receiver_cnt.mat >> inrange_cnt.mat.tmp
    cat $ALLRESDIR/$DIRNUM/receiver_byte_cnt.mat >> inrange_byte_cnt.mat.tmp

    if [ $NO_NODES -gt $MAX_NO_NODES ]; then
      MAX_NO_NODES=$NO_NODES
      MAX_NO_NODES_DIR=$DIRNUM
    fi

    if [ -f $ALLRESDIR/$DIRNUM/measurement.log ]; then
      if [ ! -f $ALLRESDIR/$DIRNUM/measurement.log.bz2 ]; then
        bzip2 -z $ALLRESDIR/$DIRNUM/measurement.log
      fi
      rm -f $ALLRESDIR/$DIRNUM/measurement.log
    fi

  fi

  let DIRNUM=DIRNUM+1

done

let DIRNUM=DIRNUM-1

while read line; do
      NODENUM=`echo $line | awk '{print $4}'`
      NODEMAC=`echo $line | awk '{print $3}'`
      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUM#g"
done < $ALLRESDIR/$MAX_NO_NODES_DIR/nodes.mac

#echo "$NODEMAC_SEDARG"

cat inrange.mat.tmp | sed "s#00-1B-B1#06-1B-B1#g" | sed $NODEMAC_SEDARG | grep -v -e "[0-9A-F]-[0-9A-F]" > inrange.mat
cat inrange_cnt.mat.tmp | sed $NODEMAC_SEDARG > inrange_cnt.mat
cat inrange_byte_cnt.mat.tmp | sed $NODEMAC_SEDARG > inrange_byte_cnt.mat

rm -f *.tmp

exit 0
