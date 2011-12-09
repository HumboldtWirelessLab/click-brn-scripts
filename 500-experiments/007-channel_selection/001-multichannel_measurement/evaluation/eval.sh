#!/bin/sh

#OUT=result.txt

#echo "CHANNEL TIME BITRATE SNR NOISE SRC DST SEQ" > $OUT

for i in `ls $1`; do
  #echo $i
  OUT=result_$i\.txt
  echo "CHANNEL TIME BITRATE SNR NOISE SRC DST SEQ" > $OUT

  for d in `ls -d $1/$i/*raw.dump`; do
    DUMP="$d"
    NODENAME=`basename $DUMP | sed "s#\.# #g" | awk '{print $1}'`
    fromdump.sh $DUMP | grep "[[:space:]]82 |" | grep "OKPacket" | grep "FF-FF-FF-FF-FF-FF" | sed "s#Mb##g" | sed "s#+##" | sed "s#/# #g" | sed "s#:##g" | awk -v NN=$NODENAME -v ID=$i '{print ID" "$2" "$5" "$6" "$7" "$12" "NN" "$15}' | human_readable.sh $1/$i/nodes.mac | sed "s#[a-z]##g" >> $OUT
    echo "$DUMP"
  done
done
