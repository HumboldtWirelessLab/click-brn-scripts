#!/bin/bash

#echo ""

if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

let SUM=0

for i in `bzcat $DIR/measurement.log.bz2 | grep tx_feedbacks | sed "s#=# #g" | sed "s#\"# #g" | awk '{print $15}'`; do
  let SUM=SUM+$i
done

PS=`bzcat $DIR/measurement.log.bz2 | grep -m 1 packet_size | sed "s#=# #g" | sed "s#\"# #g" | awk '{print $11}'`

let PS=PS+38

echo "($SUM * $PS * 8) / (1024 * 30)" | bc -l

