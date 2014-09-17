#!/bin/sh

for i in 1_MBit*; do echo -n "$i: "; cat $i/evaluation/flooding_info/floodingstats.csv; cat $i/evaluation/flow_info/flowtime.mat; done

