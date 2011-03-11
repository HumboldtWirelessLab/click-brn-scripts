#!/bin/sh

echo -n "" > all_results.mat

for i in `(cd ..;ls)`; do
  NUM=`echo $i | sed "s#_# #g" | awk '{print $1}'`
  CHANNEL=`echo $i | sed "s#_# #g" | awk '{print $3}'`
  if [ ! -f ../$i ]; then
    echo "eval $i"
    if [ -e ../$i/nodes.mac ]; then
      if [ ! -f ../$i/txpower_data.mat ]; then
        RESULTDIR=../$i/ ./read_dumps.sh
      fi
      if [ -f ../$i/txpower_data.mat ]; then
        cat ../$i/txpower_data.mat | awk -v CHANNEL=$CHANNEL '{print CHANNEL" "$0}' >> all_results.mat
      fi
    fi
  fi
done
