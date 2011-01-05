#!/bin/sh

echo "<flooding_experiment>"

if [ -e $2/experiment_info.xml ]; then
    cat $2/experiment_info.xml
fi

seq=0;
for n in `cat $1 | grep -v "#"`; do

echo "<source node=\"$n\" seq=\"$seq\">"
seq=`expr $seq + 1`

cat $2/flooding_stats.$n

echo "</source>"
done

echo "</flooding_experiment>"

