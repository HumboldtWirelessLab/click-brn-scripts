#!/bin/bash

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


if [ "x$KEEP_EVAL" = "x" ]; then
  for i in `ls -d *MBit*`; do
    (cd  $i/; rm -rf evaluation)
  done
fi

MAX_THREADS=14
NUM=0

if [ ! -f placement.txt ]; then
  cat placements_npart.dat | grep -e "^1 " | sed -e "s#^1 ##g" > placement.txt
fi

echo -n "" > $DIR/evaluation_finish

for i in `ls -d *MBit*`; do

  #ADDEVALUATION="evaluation/eval.sh network_info flooding_info flow_info"
  ADDEVALUATION="flooding_info"
  (cd $i/; if [ -f measurement.log.bz2 ]; then rm -f measurement.log; bzip2 -k -d measurement.log.bz2; fi; ADDEVALUATION="$ADDEVALUATION" /bin/bash ./eval_again.sh; if [ -f measurement.log.bz2 ]; then rm -f measurement.log; fi; echo $NUM >> $DIR/evaluation_finish ) &

  let NUM=NUM+1

  if [ $NUM -eq $MAX_THREADS ]; then
    LINES=`cat $DIR/evaluation_finish | wc -l`

    while [ $LINES -ne $NUM ]; do
      sleep 10
      LINES=`cat $DIR/evaluation_finish | wc -l`
    done
    echo -n "" > $DIR/evaluation_finish
    NUM=0
  fi
done

LINES=`cat $DIR/evaluation_finish | wc -l`

while [ $LINES -ne $NUM ]; do
  sleep 10
  LINES=`cat $DIR/evaluation_finish | wc -l`
done

rm -f $DIR/evaluation_finish placement.txt
