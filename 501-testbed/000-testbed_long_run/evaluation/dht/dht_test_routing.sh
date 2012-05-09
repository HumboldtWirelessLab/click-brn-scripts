#!/bin/sh

if [ ! -f $1 ];then
  echo "Use $0 nodefile"
  exit 0;
fi

for i in `cat $1 | grep -v "#" | awk '{print $1}'`; do
  clickctrl.sh read $i 7777 dht/dht/dhtrouting routing_info
done
