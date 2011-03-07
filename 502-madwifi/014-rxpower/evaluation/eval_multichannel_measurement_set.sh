#!/bin/sh

echo "" > all_results.mat

for i in `(cd ..;ls)`; do
  NUM=`echo $i | sed "s#_# #g" | awk '{print $1}'`
  CHANNEL=`echo $i | sed "s#_# #g" | awk '{print $3}'`
  MODE=`echo $i | sed "s#_# #g" | awk '{print $4}'`
  if [ "x$MODE" = "xadhoc" ]; then
    MODE=1
    MODOPTIONS=0
    POSITION=`echo $i | sed "s#_# #g" | awk '{print $6}'`
  else
    MODE=0
    MODOPTIONS=`echo $i | sed "s#_# #g" | awk '{print $5}' | sed "s#modoptions\.default\.395#1#g" |  sed "s#modoptions\.default#2#g"`
    POSITION=`echo $i | sed "s#_# #g" | awk '{print $8}'`
  fi
  echo $i
  if [ ! -f ../$i ]; then
    echo "eval $i"
    if [ -e ../$i/nodes.mac ]; then
      if [ ! -f ../$i/txpower_data.mat ]; then
        RESULTDIR=../$i/ ./read_dumps.sh
      fi
      if [ -f ../$i/txpower_data.mat ]; then
        cat ../$i/txpower_data.mat | awk -v NUM=$NUM -v CHANNEL=$CHANNEL -v MODE=$MODE -v MODOPTIONS=$MODOPTIONS -v POSITION=$POSITION '{print NUM" "MODE" "MODOPTIONS" "CHANNEL" "$0" "POSITION}' >> all_results.mat
      fi
    fi
  fi
done
