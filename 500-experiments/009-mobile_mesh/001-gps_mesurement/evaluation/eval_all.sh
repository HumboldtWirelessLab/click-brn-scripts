#!/bin/sh


for i in `ls $1/*dump`; do
  echo $i
  NAME=`basename $i`
  ./fromdump.sh $i | grep "92 | 11Mb" | grep "data nods FF-FF-FF-FF-FF-FF" > $NAME\.out
done