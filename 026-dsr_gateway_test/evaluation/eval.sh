#!/bin/sh

CNT_GW=`cat $RESULTDIR/measurement.log | grep -A 1 "BRNGateway" | grep "false" | wc -l`
SEND_PACKETS=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`
ECHO_PACKETS=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $13}'`
RECV_PACKETS=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`
MIRROR_PACKETS=`cat $RESULTDIR/measurement.log | grep -B 1 "<flowstats" | head -n 1`

echo -n "GW: $CNT_GW. Send $SEND_PACKETS packet, received $RECV_PACKETS packets are received. Mirror: $MIRROR_PACKETS"

if [ $CNT_GW -eq 2 ] && [ $RECV_PACKETS -gt 10 ]; then
  echo " OK !"
  exit 0
else
  if [ $CNT_GW -ne 2 ]; then
    echo "No gateway"
  else
    echo "No flow"
  fi

  exit 2
fi

exit 0
