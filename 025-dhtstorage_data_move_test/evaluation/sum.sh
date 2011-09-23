#!/bin/sh

SUM=0

while read line; do

  SUM=`expr $SUM + $line`

done <&0

echo $SUM

exit 0
