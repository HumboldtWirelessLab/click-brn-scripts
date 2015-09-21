#!/bin/bash

#echo ""

let SUM=0

for i in `cat 1/measurement.log | grep tx_feedbacks | sed "s#=# #g" | sed "s#\"# #g" | awk '{print $15}'`; do
  let SUM=SUM+$i
done

PS=`cat 1/measurement.log | grep -m 1 packet_size | sed "s#=# #g" | sed "s#\"# #g" | awk '{print $11}'`


let "TP=($SUM*($PS+38)) / (1024*30)"
#echo "tp:   " $TP "kbit/s"
echo $TP
