#!/bin/sh

if [ ! -f $1 ];then
  echo "Use $0 nodefile"
  exit 0;
fi

NODECOUNT=`cat $1 | grep "-" | wc -l`

for i in `seq 1 1000`; do
  NODENUM=`expr $RANDOM % $NODECOUNT + 1`
  #echo $NODENUM

  NODE=`cat $1 | grep -e "[[:space:]]$NODENUM$" | awk '{print $1}'`
  #echo $NODE

  clickctrl.sh write $NODE 7777 dhtstoragetest test "read key$i"
  sleep 5
  clickctrl.sh read $NODE 7777 dhtstoragetest test
  sleep 1
done

sleep 10

for i in `cat $1 | grep -v "#" | awk '{print $1}'`; do
  clickctrl.sh read $i 7777 dhtstoragetest stats
  clickctrl.sh read $i 7777 dhtstorage/dhtstorage stats
done

