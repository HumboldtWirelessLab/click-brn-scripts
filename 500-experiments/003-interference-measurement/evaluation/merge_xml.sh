#!/bin/sh

echo "<interference_experiment>"

if [ -e $1/interference_info.xml ]; then
    cat $1/interference_info.xml
fi

seq=0;
for n in `(cd $1; ls ig_stat*)`; do

NODE=`echo $n | sed "s#\.# #g" | awk '{print $2}'`

echo "<source node_a=\"$NODE\" node_b=\"none\" seq=\"$seq\" pre_stats=\"10\" dur_stats=\"1\" post_stats=\"10\" >"
seq=`expr $seq + 1`

cat $1/$n | human_readable.sh

echo "</source>"
done

echo "</interference_experiment>"
