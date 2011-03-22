#!/bin/sh

echo -n "" > all_results.mat

GEN_NODENAME_MAT=0

for i in `(cd ..;ls)`; do
  NUM=`echo $i | sed "s#_# #g" | awk '{print $1}'`
  CHANNEL=`echo $i | sed "s#_# #g" | awk '{print $3}'`
  MODE=`echo $i | sed "s#_# #g" | awk '{print $4}'`
  if [ "x$MODE" = "xadhoc" ]; then
    MODE=1
    MODOPTIONS=0
    POSITION=`echo $i | sed "s#_# #g" | awk '{print $6}'`
    POWER=`echo $i | sed "s#_# #g" | awk '{print $8}'`
  else
    MODE=0
    MODOPTIONS=`echo $i | sed "s#_# #g" | awk '{print $5}' | sed "s#modoptions\.default\.395#1#g" |  sed "s#modoptions\.default#2#g" | sed "s#modoptions\.germany#3#g"`
    POSITION=`echo $i | sed "s#_# #g" | awk '{print $8}'`
    POWER=`echo $i | sed "s#_# #g" | awk '{print $10}'`
  fi
  if [ "x$POSITION" = "x" ]; then
    POSITION=0
  fi
  echo $i
  if [ ! -f ../$i ]; then
    echo "eval $i"
    if [ -e ../$i/nodes.mac ]; then
      if [ ! -f ../$i/txpower_data.mat ]; then
        WANTEDDEVICE=$WANTEDDEVICE WANTEDNODE=$WANTEDNODE RESULTDIR=../$i/ ./read_bidirect_dumps.sh
      fi
      if [ -f ../$i/txpower_data.mat ]; then
        if [ "x$POWER" = "x" ]; then
          cat ../$i/txpower_data.mat | awk -v NUM=$NUM -v CHANNEL=$CHANNEL -v MODE=$MODE -v MODOPTIONS=$MODOPTIONS -v POSITION=$POSITION '{print NUM" "MODE" "MODOPTIONS" "CHANNEL" "POSITION" "$0}' >> all_results.mat
        else
          cat ../$i/txpower_data.mat | awk -v NUM=$NUM -v CHANNEL=$CHANNEL -v MODE=$MODE -v MODOPTIONS=$MODOPTIONS -v POSITION=$POSITION -v POWER=$POWER '{print NUM" "MODE" "MODOPTIONS" "CHANNEL" "POSITION" "POWER" "$0}' >> all_results.mat
        fi
      fi
    fi
  fi

  if [ $GEN_NODENAME_MAT -eq 0 ]; then
    cat ../$i/nodes.mac | awk '{print $1" "$2" "$3" "$4}' > all_nodes.mat
    GEN_NODENAME_MAT=1
  fi
done
