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

if [ ! -e $EVALUATIONSDIR ]; then
  mkdir -p $EVALUATIONSDIR
fi

if [ "$MODE" = "sim" ]; then
  if [ -f $RESULTDIR/measurement.log ]; then
    OVERALL=`cat $RESULTDIR/measurement.log | grep "OKP" | wc -l`
    echo "Overall: $OVERALL"
    echo -n "$OVERALL" > $EVALUATIONSDIR/result.txt
    for i in `cat $RESULTDIR/nodes.mac | awk '{print $3}'`; do
      NODEP=`cat $RESULTDIR/measurement.log | grep "OKP" | grep $i | wc -l`
      echo "$i: $NODEP"
      echo -n ",$NODEP" >> $EVALUATIONSDIR/result.txt
    done
  fi
fi

RES=`cat $EVALUATIONSDIR/result.txt`
xsltproc --stringparam result "$RES" $DIR/t2qm_queue_usage.xslt $EVALUATIONSDIR/measurement.xml > $EVALUATIONSDIR/queueusage.csv
xsltproc --stringparam result "$RES" $DIR/t2qm_backoff_usage.xslt $EVALUATIONSDIR/measurement.xml > $EVALUATIONSDIR/backoffusage.csv

echo "" >> $EVALUATIONSDIR/result.txt

cat $EVALUATIONSDIR/queueusage.csv | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac | sed -e "s#,# #g" > $EVALUATIONSDIR/queueusage.mat
cat $EVALUATIONSDIR/backoffusage.csv | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac | sed -e "s#,# #g" > $EVALUATIONSDIR/backoffusage.mat

exit 0
