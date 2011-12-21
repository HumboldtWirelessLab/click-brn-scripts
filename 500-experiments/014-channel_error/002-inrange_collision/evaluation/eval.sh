#!/bin/sh

if [ "x$MODE" = "xsim" ]; then
  if [ "x$SIM" = "xns2" ]; then
    SEND_PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "^s " | wc -l`
    RETRIES_PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "MAC  RET " | wc -l`
    COLL_PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "MAC  COL " | wc -l`
    RECV_PACKETS=`cat $RESULTDIR/receiver.tr | grep -e "^r " | wc -l`
    
    SEND_ALL=`expr $SEND_PACKETS + $RETRIES_PACKETS`
  fi
fi

echo "SEND: $SEND_ALL ($SEND_PACKETS/$RETRIES_PACKETS) RECV: $RECV_PACKETS COL: $COLL_PACKETS"

exit 0
