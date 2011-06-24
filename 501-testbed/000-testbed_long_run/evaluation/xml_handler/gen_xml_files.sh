#!/bin/sh

NODES=`cat $1 | grep -v "#"`


for n in $NODES; do

  IP=`nslookup $n | grep "Address:" | tail -n 1 | awk '{print $2}'`

  while read inline; do

   ELEMENT=`echo $inline | awk '{print $1}'`
   HANDLER=`echo $inline | awk '{print $2}'`

   ES=`echo $ELEMENT | sed "s#/#_#g"`
   HS=`echo $HANDLER | sed "s#/#_#g"`
   IPS=`echo $IP | sed "s#\.#_#g"`

   clickctrl.sh read $n 7777 $ELEMENT $HANDLER > $IPS\_7777_$ES\_$HS

  done < $2

done