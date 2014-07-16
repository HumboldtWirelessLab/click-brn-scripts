#!/bin/bash

# set working dir
if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

# get nodes used in sim
NODES=`cat $DIR/nodes.mac | awk '{print $3}'`

for node in $NODES; do
  FEEDBACKS=`cat $DIR/measurement.log | grep "txflow" | grep $node | sed 's#=# #g' | awk '{print $15}'`

  echo "$node $FEEDBACKS"
done
