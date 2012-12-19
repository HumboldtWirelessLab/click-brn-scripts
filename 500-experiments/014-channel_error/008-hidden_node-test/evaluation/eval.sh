#!/bin/sh

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
fi

#echo "SEND: $SEND_ALL ($SEND_PACKETS/$RETRIES_PACKETS) RECV: $RECV_PACKETS COL: $COLL_PACKETS"
echo "$NUM $NO_NODES $PACKETSIZE $BACKOFF $BACKOFF_MAX $SEND_ALL $SEND_PACKETS $RETRIES_PACKETS $RECV_PACKETS $COLL_PACKETS $RECV_APP_PACKETS $RECV_APP_BYTES $RATE"

if [ -e $RESULTDIR/../measurement_logdir ]; then
  cp $RESULTDIR/measurement.log $RESULTDIR/../measurement_logdir/$NUM.log
fi

exit 0
