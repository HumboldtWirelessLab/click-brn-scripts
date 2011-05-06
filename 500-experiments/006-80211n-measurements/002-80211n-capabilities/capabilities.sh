#!/bin/sh

ALL_NODES=`cat all_nodes | grep -v "#"`

echo -n "" > performance_results.txt

for SENDER in $ALL_NODES; do
  rm -rf receiver sender
  echo $SENDER > sender
  cat all_nodes | grep -v "#" | grep -v $SENDER > receiver

  MODE="REBOOT"
  for i in `seq 1 10`; do
    NAME=$SENDER"_"$i
    RUNMODE=$MODE run_measurement.sh sender_and_receiver.dis $NAME

    echo -n "$SENDER $i" >> performance_results.txt

    for node in `cat receiver`; do
      RATEPOS=`cat $NAME/$node.wlan0.log | awk '{print NR" "$0}' | grep "cnt.bit_rate" | awk '{print $1}'`
      RATRPOS=`expr $RATEPOS + 1`
      RATE=`cat $NAME/$node.wlan0.log | head -n $RATEPOS | tail -n 1 | awk '{print $1}'`
      echo -n " $node $RATE" >> performance_results.txt
    done

    MODE="CLICK"

    echo "" >> performance_results.txt

  done

done

rm -rf receiver sender
