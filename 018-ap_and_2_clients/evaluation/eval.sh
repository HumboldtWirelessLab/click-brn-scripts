#!/bin/sh

SEND_PACKETS=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`
ECHO_PACKETS=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $13}'`
RECV_PACKETS=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`

if [ "x$ECHO_PACKETS" = "x" ]; then
  ECHO_PACKETS=0
fi
  
if [ "x$RECV_PACKETS" = "x" ]; then
  RECV_PACKETS=0
fi

echo -n "Send $SEND_PACKETS packet, received $ECHO_PACKETS packets and $RECV_PACKETS echo packets are received."

if [ $ECHO_PACKETS -ge 5 ]; then
  echo " OK !"
  exit 0
else
  echo " Too bad !"
  exit 2
fi
