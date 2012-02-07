#!/bin/sh

SEND_PACKETS=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`
ECHO_PACKETS=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $13}'`
RECV_PACKETS=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`

echo -n "Send $SEND_PACKETS packet, received $RECV_PACKETS packets and $ECHO_PACKETS echo packets are received."

if [ $ECHO_PACKETS -gt 10 ]; then
  echo " OK !"
  exit 0
else
  echo " Too bad !"
  exit 2
fi
