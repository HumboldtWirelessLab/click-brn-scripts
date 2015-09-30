#!/bin/sh

. $CONFIGFILE

if [ ! -e $EVALUATIONSDIR ]; then
  mkdir -p $EVALUATIONSDIR
fi


RECV_PACKETS_1=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}' | head -n 1`
RECV_PACKETS_2=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}' | tail -n 1`
PACKET_SIZE_1=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $11}' | head -n 1`
PACKET_SIZE_2=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $11}' | tail -n 1`
COL=`cat $RESULTDIR/ | grep COL | wc -l`


if [ "x$RECV_PACKETS_1" = "x" ]; then
  PACKET_SIZE=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $11}' | tail -n 1`
  echo "0 0 $PACKET_SIZE $PACKET_SIZE" > $EVALUATIONSDIR/stats
else
  echo "$RECV_PACKETS_1 $RECV_PACKETS_2 $PACKET_SIZE_1 $PACKET_SIZE_2" > $EVALUATIONSDIR/stats
fi

exit 0
