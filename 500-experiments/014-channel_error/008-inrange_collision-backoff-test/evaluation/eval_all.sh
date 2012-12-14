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

echo "NUM,NO_NODES,PACKETSIZE,BACKOFF,BACKOFF_MAX,SEED,RATE,TIME,NODE,ID,PHY_HWBUSY,PHY_HWRX,PHY_HWTX,RXPKT,CRCPKT,PHYPKT,ADDR,RSSI,STDRSSI,MINRSSI,MAXRSSI,PKTCNT" > inrange.mat.tmp
echo "NUM,NO_NODES,PACKETSIZE,BACKOFF,BACKOFF_MAX,SEED,RATE,PACKETCOUNT" > inrange_cnt.mat.tmp
echo "NUM,NO_NODES,PACKETSIZE,BACKOFF,BACKOFF_MAX,SEED,RATE,BYTECOUNT" > inrange_byte_cnt.mat.tmp

while [ -e $ALLRESDIR/$DIRNUM ]; do

  CONFIGFILE=$ALLRESDIR/$DIRNUM/sender_and_receiver.des.real RESULTDIR=$ALLRESDIR/$DIRNUM $DIR/eval.sh

  cat $ALLRESDIR/$DIRNUM/receiver_info.mat >> inrange.mat.tmp
  cat $ALLRESDIR/$DIRNUM/receiver_cnt.mat >> inrange_cnt.mat.tmp
  cat $ALLRESDIR/$DIRNUM/receiver_byte_cnt.mat >> inrange_byte_cnt.mat.tmp

  let DIRNUM=DIRNUM+1

done

let DIRNUM=DIRNUM-1

while read line; do
      NODENUM=`echo $line | awk '{print $4}'`
      NODEMAC=`echo $line | awk '{print $3}'`
      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUM#g"
done < $ALLRESDIR/$DIRNUM/nodes.mac

cat inrange.mat.tmp | sed "s#00-1B-B1#06-1B-B1#g" | sed $NODEMAC_SEDARG | grep -v "-" > inrange.mat
cat inrange_cnt.mat.tmp | sed $NODEMAC_SEDARG > inrange_cnt.mat
cat inrange_byte_cnt.mat.tmp | sed $NODEMAC_SEDARG > inrange_byte_cnt.mat

rm -f *.tmp

exit 0
