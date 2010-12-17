#!/bin/sh

VAL_RATE="2 12"
VAL_TXPOWER="19 10"
VAL_PACKETSIZE="192 992"
VAL_CHANNEL="1 14"
VAL_PACKETS="10"

for c in $VAL_CHANNEL; do
  for r in $VAL_RATE; do
    for p in $VAL_TXPOWER; do
      for s in $VAL_PACKETSIZE; do
        for n in $VAL_PACKETS; do
	  NEXT_DIR=channel_$c\_rate_$r\_rxpower_$p\_size_$s\_count_$n
	  mkdir $NEXT_DIR
	  echo "$c;$r;$p;$s;$n" > $NEXT_DIR/setup.mat
	  CHANNEL=$c RATE=$r TXPOWER=$p PACKETSIZE=$s PACKETS=$n ../../event_setup.sh ../../nodes 100 > $NEXT_DIR/flooding-test.ctl 
	  (cd $NEXT_DIR; handler_control.sh ./flooding-test.ctl ../../nodes.mac > ./result.log 2>&1)
	  sleep 10
        done
      done
    done
  done    
done
