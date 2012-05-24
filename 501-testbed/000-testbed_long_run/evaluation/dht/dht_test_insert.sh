#!/bin/sh

if [ ! -f $1 ];then
  echo "Use $0 nodefile"
  exit 0;
fi

for i in `cat $1 | grep -v "#" | awk '{print $1}'`; do
  clickctrl.sh read $i 7777 dhtstorage/dhtstorage stats
done

for i in `seq 1 1000`; do
  clickctrl.sh write sk110 7777 dhtstoragetest test "write key$i value$i"
  sleep 5
done

clickctrl.sh read sk110 7777 dhtstoragetest stats

sleep 10

for i in `cat $1 | grep -v "#" | awk '{print $1}'`; do
  clickctrl.sh read $i 7777 dhtstorage/dhtstorage stats
done


#clickctrl.sh write wgt72 7777 dhtstoragetest test "read 100"
#clickctrl.sh read wgt72 7777 dhtstoragetest test
