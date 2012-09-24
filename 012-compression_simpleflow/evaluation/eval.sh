#!/bin/sh

SEND_PACKETS=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`
RECV_PACKETS=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $9}'`
ERR_PACKETS=`cat $RESULTDIR/measurement.log | grep "<rxflow src=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $17}'`

echo -n "Send $SEND_PACKETS packet and $RECV_PACKETS packets are received. $ERR_PACKETS errors."

if [ $RECV_PACKETS -gt 10 ] && [ $ERR_PACKETS -eq 0 ]; then
  echo " OK !"
  exit 0
else
  echo " Too bad !"
  exit 2
fi
