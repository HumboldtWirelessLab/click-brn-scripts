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

. $CONFIGFILE
. $RESULTDIR/params

if [ "x$MODE" = "xsim" ]; then
  if [ "x$SIM" = "xns2" ]; then
    SEND_PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "^s " | wc -l`
    RETRIES_PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "MAC  RET " | wc -l`
    COLL_PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "MAC  COL " | wc -l`
    RECV_PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "^r " | wc -l`

    RECV_APP_PACKETS=`cat $RESULTDIR/measurement.log | grep -A 1 cnt.count | tail -n 1`
    RECV_APP_BYTES=`cat $RESULTDIR/measurement.log | grep -A 1 cnt.byte_count | tail -n 1`

    SEND_ALL=`expr $SEND_PACKETS + $RETRIES_PACKETS`
  fi

  #echo "SEND: $SEND_ALL ($SEND_PACKETS/$RETRIES_PACKETS) RECV: $RECV_PACKETS COL: $COLL_PACKETS"
  echo "$NUM $NO_NODES $PACKETSIZE $BACKOFF $BACKOFF_MAX $SEND_ALL $SEND_PACKETS $RETRIES_PACKETS $RECV_PACKETS $COLL_PACKETS $RECV_APP_PACKETS $RECV_APP_BYTES $RATE"

else

  RECEIVER=`cat $NODETABLE | grep "receiver.click" | awk '{print $1}'`
  RECEIVERLOG=`cat $NODETABLE | grep "receiver.click" | awk '{print $8}'`

  RECEIVER_XML=$RESULTDIR/receiver.xml

  if [ ! -f $RECEIVER_XML ]; then
    echo "<channelloadmeasurement num='$NUM' no_nodes='$NO_NODES' packetsize='$PACKETSIZE' backoff='$BACKOFF' backoff_max='$BACKOFF_MAX' seed='$SEED' rate='$RATE' >" > $RECEIVER_XML
    cat $RECEIVERLOG | egrep "[:space:]*<" >> $RECEIVER_XML
    echo "</channelloadmeasurement>" >> $RECEIVER_XML
  fi

  xsltproc $DIR/channelload.xslt $RECEIVER_XML > $RESULTDIR/receiver_info.mat

  for i in `cat $RECEIVERLOG | grep -A 1 "cnt.count" | grep -v "cnt.count"`; do
    echo "$NUM,$NO_NODES,$PACKETSIZE,$BACKOFF,$BACKOFF_MAX,$SEED,$RATE,$i" > $RESULTDIR/receiver_cnt.mat
  done

  for i in `cat $RECEIVERLOG | grep -A 1 "cnt.byte_count" | grep -v "cnt.byte_count"`; do
    echo "$NUM,$NO_NODES,$PACKETSIZE,$BACKOFF,$BACKOFF_MAX,$SEED,$RATE,$i" > $RESULTDIR/receiver_byte_cnt.mat
  done

fi

exit 0
