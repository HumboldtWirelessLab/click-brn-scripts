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

MAX_THREADS=20
NUM=0

echo -n "" > $DIR/evaluation_finish

for i in `ls -d *MBit*`; do

  #ADDEVALUATION="evaluation/eval.sh flooding_info flow_info evaluation/eval_post.sh"
  (cd $i/; PREEVALUATION="$PREEVALUATION" ADDEVALUATION="$ADDEVALUATION" eval_again.sh; echo $NUM >> $DIR/evaluation_finish ) &

  let NUM=NUM+1

  if [ $NUM -eq $MAX_THREADS ]; then
    LINES=`cat $DIR/evaluation_finish | wc -l`

    while [ $LINES -ne $NUM ]; do
      sleep 1
      LINES=`cat $DIR/evaluation_finish | wc -l`
    done
    echo -n "" > $DIR/evaluation_finish
    NUM=0
  fi
done

LINES=`cat $DIR/evaluation_finish | wc -l`

while [ $LINES -ne $NUM ]; do
  sleep 1
  LINES=`cat $DIR/evaluation_finish | wc -l`
done

rm -f $DIR/evaluation_finish
