#!/bin/sh

for i in `cat proto_map.dat | awk '{print $2}'`; do
  PROTO=`echo $i | sed "s#_# #g" | awk '{print $1}'`
  DEFINE=`echo $i | awk '{print $3}'`
  echo "$PROTO $DEFINE"

  echo "#define $DEFINE" >> routing_simpleflow.inc
  run_sim.sh ns routing_simpleflow.des $PROTO
done