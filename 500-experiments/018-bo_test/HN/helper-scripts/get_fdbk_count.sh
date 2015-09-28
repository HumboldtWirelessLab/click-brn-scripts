#!/bin/bash


if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

echo ""

if [ "x$BZIP" == "x1" ]; then
	bzcat $DIR/measurement.log.bz2 | grep tx_feedbacks | sed "s#=# #g" | sed "s#\"# #g" | awk '{print $3 " " $9 " " $15}'
else
	cat $DIR/measurement.log | grep tx_feedbacks | sed "s#=# #g" | sed "s#\"# #g" | awk '{print $3 " " $9 " " $15}'
fi
