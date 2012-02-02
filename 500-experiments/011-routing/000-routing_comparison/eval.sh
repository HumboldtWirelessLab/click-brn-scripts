#!/bin/sh

NUM=1;
echo -n "" > result.dat
echo -n "" > proto_map.dat

for i in `ls *_routing.click`; do
  PROTO=`echo $i | sed "s#_# #g" | awk '{print $1}'`
  REQUESTS_TX=`cat $PROTO/measurement.log | grep "<txflow src=" | sed "s#\"# #g" | awk '{print $9}'`
  REQUESTS_RX=`cat $PROTO/measurement.log | grep "<rxflow src=" | sed "s#\"# #g" | awk '{print $9}'`
  REPLIES=`cat $PROTO/measurement.log | grep "<txflow src=" | sed "s#\"# #g" | awk '{print $13}'`
  HOPS=`cat $PROTO/measurement.log | grep "<txflow src=" | sed "s#\"# #g" | awk '{print $15}'`
  RTT=`cat $PROTO/measurement.log | grep "<txflow src=" | sed "s#\"# #g" | awk '{print $17}'`
  echo $PROTO
  cat $PROTO/measurement.log | grep -A 1 "routing_cnt.byte_count" | grep -v "\-\-" | grep -v "routing_cnt.byte" | awk -v NUM=$NUM -v RTX=$REQUESTS_TX -v RRX=$REQUESTS_RX -v REP=$REPLIES -v HOPS=$HOPS -v RTT=$RTT '{print "1 "NUM" "$0" "RTX" "RRX" "REP" "HOPS" "RTT}' >> result.dat
  cat $PROTO/measurement.log | grep -A 1 "routing_cnt.count" | grep -v "\-\-" | grep -v "routing_cnt.count" | awk -v NUM=$NUM -v RTX=$REQUESTS_TX -v RRX=$REQUESTS_RX -v REP=$REPLIES -v HOPS=$HOPS -v RTT=$RTT '{print "2 "NUM" "$0" "RTX" "RRX" "REP" "HOPS" "RTT}' >> result.dat
  echo "$NUM $PROTO" >> proto_map.dat
  NUM=`expr $NUM + 1`
done