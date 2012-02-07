#!/bin/sh

for i in `ls *_routing.click`; do
  PROTO=`echo $i | sed "s#_# #g" | awk '{print $1}'`
  echo $PROTO
  rm -f routing.click
  ln -s $i  routing.click
  run_sim.sh ns routing_simpleflow.des $PROTO
done