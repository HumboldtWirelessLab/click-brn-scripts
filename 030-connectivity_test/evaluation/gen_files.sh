#!/bin/bash

MACLIST=`cat $1 | grep -v "WARN" | grep "00-" | awk '{print $1}' | sort -u`

for i in $MACLIST; do
  NR=`echo $i | sed "s#-# #g" | awk '{print $5}' | sed -e "s#^0*##g"`
  echo "node$NR $i" >> nodelist
done
