#!/bin/sh

for i in `ls *.txt`; do

  POWER=`echo $i | sed "s#_# #g" | awk '{print $2}'`
  LINK=`echo $i | sed -e "s#_# #g" -e "s#\.# #g" | awk '{print $3}'`
  
  cat $i | awk -v POWER=$POWER -v LINK=$LINK '{print POWER" "LINK" "$0}'
done

