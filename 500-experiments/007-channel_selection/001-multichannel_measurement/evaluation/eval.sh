#!/bin/sh

#OUT=result.txt

#echo "CHANNEL TIME BITRATE SNR NOISE SRC DST SEQ" > $OUT

TESTDUMP=`find $1 -name *raw.dump  | head -n 1`
SEARCHSIZE=`fromdump.sh $TESTDUMP  | grep TX | awk '{print $3}' | head -n 1`

for i in `ls $1`; do
  #echo $i
  if [ -f $1/$i/params ]; then
    . $1/$i/params

    #OUT=result_$i\.txt
    OUT=result.txt
    echo "CHANNEL TIME BITRATE SNR NOISE SRC DST SEQ" > $OUT

    for d in `ls -d $1/$i/*raw.dump`; do
      DUMP="$d"
      NODENAME=`basename $DUMP | sed "s#\.# #g" | awk '{print $1}' | NAME2NUM=1 human_readable.sh $1/$i/nodes.mac`
      fromdump.sh $DUMP | grep "[[:space:]]$SEARCHSIZE |" | grep "OKPacket" | grep "FF-FF-FF-FF-FF-FF" | sed -e "s#Mb##g" -e "s#+##" -e "s#/# #g" -e "s#:##g" | awk -v NN=$NODENAME -v ID=$CHANNEL '{print ID" "$2" "$5" "$6" "$7" "$12" "NN" "$15}' | MAC2NUM=1 human_readable.sh $1/$i/nodes.mac  >> $OUT
      echo "$DUMP"
    done
  fi
done
