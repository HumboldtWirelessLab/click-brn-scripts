#!/bin/bash

if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

cat $DIR/measurement.log | grep "tx_rate" | sed 's#=# #g' | awk '{print $3, $17}' | sed 's#\"# #g' | awk '{print $1, $2 / 8000, "kB/s"}'
