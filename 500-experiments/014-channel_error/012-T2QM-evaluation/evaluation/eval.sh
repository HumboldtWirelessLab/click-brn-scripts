#!/bin/sh

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
  "/")
      DIR=$dir
      ;;
  ".")
      DIR=$pwd/$dir
      ;;
    *)
      echo "Error while getting directory"
      exit -1
      ;;
esac

. $CONFIGFILE

FILLUPTO=50

if [ ! -e $EVALUATIONSDIR ]; then
  mkdir -p $EVALUATIONSDIR
fi

if [ "$MODE" = "sim" ]; then

  if [ -f $RESULTDIR/measurement.log.bz2 ]; then
    ( cd $RESULTDIR; bzip2 -d -k measurement.log.bz2 )
  fi

  if [ -f $RESULTDIR/measurement.log ]; then
    OVERALL=`cat $RESULTDIR/measurement.log | grep "OKP" | grep "data" | wc -l`
    #echo "Overall: $OVERALL"
    echo -n "$OVERALL" > $EVALUATIONSDIR/result.csv
    NODES=0
    for i in `cat $RESULTDIR/nodes.mac | awk '{print $3}'`; do
      NODEP=`cat $RESULTDIR/measurement.log | grep "OKP" | grep $i | wc -l`
      #echo "$i: $NODEP"
      echo -n ",$NODEP" >> $EVALUATIONSDIR/result.csv
      let NODES=NODES+1
    done
    while [ $NODES -lt $FILLUPTO ]; do
      echo -n ",0" >> $EVALUATIONSDIR/result.csv
      let NODES=NODES+1
    done
  fi
  if [ -f $RESULTDIR/measurement.log.bz2 ]; then
    ( cd $RESULTDIR; rm measurement.log )
  fi
fi


if [ -f $EVALUATIONSDIR/channelstats/simstats_summary.csv ]; then
  COLS=`awk -F, '{print $14}' $EVALUATIONSDIR/channelstats/simstats_summary.csv`
else
  # get collision count
  if [ -f $RESULTDIR/receiver.tr.bz2 ]; then
    COLS=`bzcat -q $RESULTDIR/receiver.tr.bz2 | grep COL | wc -l`
  else
    if [ -f $RESULTDIR/receiver.tr ]; then
      COLS=`cat $RESULTDIR/receiver.tr | grep COL | wc -l`
    fi
  fi
fi

echo -n ",$COLS" >> $EVALUATIONSDIR/result.csv
echo "" >> $EVALUATIONSDIR/result.csv

xsltproc $DIR/t2qm_queue_usage.xslt $EVALUATIONSDIR/measurement.xml > $EVALUATIONSDIR/queueusage.csv
xsltproc $DIR/t2qm_backoff_usage.xslt $EVALUATIONSDIR/measurement.xml > $EVALUATIONSDIR/backoffusage.csv
xsltproc $DIR/t2qm_bo_values.xslt $EVALUATIONSDIR/measurement.xml > $EVALUATIONSDIR/bo_values.csv


cat $EVALUATIONSDIR/result.csv | sed -e "s#,# #g" > $EVALUATIONSDIR/result.mat

cat $EVALUATIONSDIR/queueusage.csv | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac | sed -e "s#,# #g" > $EVALUATIONSDIR/queueusage.mat
cat $EVALUATIONSDIR/backoffusage.csv | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac | sed -e "s#,# #g" > $EVALUATIONSDIR/backoffusage.mat
cat $EVALUATIONSDIR/bo_values.csv | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac | sed -e "s#,# #g" > $EVALUATIONSDIR/bovalues.mat

#cat $RESULTDIR/params

if [ -f $RESULTDIR/params ]; then

  . $RESULTDIR/params

  CHANNEL_MODEL=`echo $CHANNEL_MODEL | sed -e "s#real#0#g" -e "s#shadowing#1#g" -e "s#tworayground#2#g"`
  PKT_TARGET=`echo $PKT_TARGET | sed -e "s#USE_BROADCAST#0#g" -e "s#USE_UNICAST#1#g"`
  TARGET=`echo $TARGET | sed -e "s#USE_BROADCAST#0#g" -e "s#USE_UNICAST#1#g"`

  #NUM=1
  #NO_NODES=2
  #PACKETSIZE=1500
  #TOS2QUEUEMAPPER_STRATEGY=0
  #SEED=1
  #RATE=125
  #TARGET=USE_BROADCAST
  #CHANNEL_MODEL=shadowing

  echo "$NUM $NO_NODES $PACKETSIZE $TOS2QUEUEMAPPER_STRATEGY $RATE $TARGET $CHANNEL_MODEL $QUEUEMAPPING $MACBOSCHEME $FIXEDBO" > $RESULTDIR/params_string

fi

rm -f $RESULTDIR/*.*
bzip2 -z $EVALUATIONSDIR/measurement.xml
rm -f $EVALUATIONSDIR/*.csv

exit 0
