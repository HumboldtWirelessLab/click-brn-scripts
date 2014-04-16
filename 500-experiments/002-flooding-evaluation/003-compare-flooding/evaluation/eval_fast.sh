#!/bin/sh

for i in `ls -d 1_M*`; do 

echo -n "$i: ";

SEND=`awk -F, '{print $6}' $i/evaluation/flooding_info/floodingstats.csv`
RTS=`cat $i/simpleflooding.tr | grep -e "^s.*RTS" | wc -l`
CTS=`cat $i/simpleflooding.tr | grep -e "^s.*CTS" | wc -l`
COL=`cat $i/simpleflooding.tr | grep -e "COL" | wc -l`

let SEND_ALL=SEND+RTS+CTS

echo "$SEND_ALL $SEND $RTS $CTS $COL"

done

exit 0
