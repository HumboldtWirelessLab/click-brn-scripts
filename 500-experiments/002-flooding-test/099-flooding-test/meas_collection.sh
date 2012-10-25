#!/bin/sh

#Hier mehrer
VAL_RATE="2" 
#"2 12 72"
VAL_TXPOWER="19"
#"19 10"
VAL_PACKETSIZE="192"
VAL_CHANNEL="1"
#"11 6 1"
VAL_PACKETS="100"

for c in $VAL_CHANNEL; do
  for r in $VAL_RATE; do
    for p in $VAL_TXPOWER; do
      for s in $VAL_PACKETSIZE; do
        for n in $VAL_PACKETS; do
          if [ "$c" != "14" ] || [ "$r" = "2" ]; then
	    NEXT_DIR=channel_$c\_rate_$r\_rxpower_$p\_size_$s\_count_$n
	    mkdir $NEXT_DIR
	    echo "$c;$r;$p;$s;$n" > $NEXT_DIR/setup.mat
	    CHANNEL=$c RATE=$r TXPOWER=$p PACKETSIZE=$s PACKETS=$n ../../event_setup.sh ../../nodes 100 > $NEXT_DIR/flooding-test.ctl
	    DATE=`date +"%Y-%m-%d"`
	    TIME=`date +"%T"`
	    echo "<experiment_info date=\"$DATE\" time=\"$TIME\" channel=\"$c\" rate=\"$r\" txpower=\"$p\" packetsize=\"$s\" packet_count=\"$n\" />" > $NEXT_DIR/experiment_info.xml
	    (cd $NEXT_DIR; handler_control.sh ./flooding-test.ctl ../../nodes.mac > ./result.log 2>&1)
	    sleep 10
	  fi
        done
      done
    done
  done
done
