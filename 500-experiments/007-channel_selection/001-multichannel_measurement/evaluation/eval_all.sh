#!/bin/sh

OUT=result.txt
echo "CHANNEL TIME BITRATE SNR NOISE SRC DST SEQ REP NUM" > $OUT

for i in `ls $1`; do
  #echo $i
  if [ -f $1/$i/evaluation/network_info/packet_rxstats.txt ]; then
    cat $1/$i/evaluation/network_info/packet_rxstats.txt >> $OUT
  fi
done
