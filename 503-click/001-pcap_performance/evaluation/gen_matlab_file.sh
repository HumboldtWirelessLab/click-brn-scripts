#!/bin/sh

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR=$1
fi

RESULTFILE=loadavg_result.mat

echo -n "" > $RESULTFILE

for d in `(cd $RESULTDIR; ls *)`; do
  if [ -d $RESULTDIR/$d ]; then
    if [ -f $RESULTDIR/$d/loadavg.values ]; then
      NUM=`echo $i | sed "s#_# #g" | awk '{print $1}'`
      MODE=`echo $i | sed "s#_# #g" | awk '{print $2}' | sed -e "s#USE_PCAP#1#g" -e "s#USE_NOPCAP#0#g"`
      cat $RESULTDIR/$d/loadavg.values | awk -v NUM=$NUM -v MODE=$MODE '{print NUM" "MODE" "$0}' >> $RESULTFILE
    fi
  fi
done
