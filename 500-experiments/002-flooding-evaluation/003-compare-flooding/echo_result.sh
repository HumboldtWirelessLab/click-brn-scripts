#!/bin/sh

for i in 1_MBit*; do echo -n "$i: ";
  cat $i/evaluation/flooding_info/floodingstats.mat | awk '{print $6" "$3}';
 # cat $i/flooding.click.eth0 | grep OverlayFlooding;
 # cat $i/evaluation/flow_info/flowtime.mat;
done

