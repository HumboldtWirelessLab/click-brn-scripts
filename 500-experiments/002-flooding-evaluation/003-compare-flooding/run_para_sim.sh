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

MAX_THREADS=20
NUM=0

echo -n "" > $DIR/sim_finish
echo -n "" > $DIR/sim_run

COUNT_SIMS=`find -name run_again.sh | wc -l`
FINISHEDSIMS=0

for i in `find -name run_again.sh`; do

  SIMDIR=`dirname $i`

  if [ -f $SIMDIR/time.stats ]; then
    TERMBYSIG=`cat $SIMDIR/time.stats | grep "terminated by signal" | wc -l`
    if [ $TERMBYSIG -eq 0 ]; then
      FILESIZE=`wc -c $SIMDIR/time.stats | awk '{print $1}'`
    else
      FILESIZE=0
    fi
  else
    FILESIZE=0
  fi

  if [ $FILESIZE -eq 0 ]; then
    echo $SIMDIR
    (cd  $SIMDIR/;sh ./run_again.sh > run_again.log 2>&1; sh ./eval_again.sh > eval_again.log 2>&1; cd $DIR; echo $NUM >> $DIR/sim_finish ) &
    echo "$NUM" >> $DIR/sim_run
  fi

  let NUM=NUM+1

  SIM_RUN=`cat $DIR/sim_run | wc -l`
  SIM_FIN=`cat $DIR/sim_finish | wc -l`

  let SIM_DIFF=SIM_RUN-SIM_FIN

  while [ $SIM_DIFF -gt $MAX_THREADS ]; do
    sleep 5
    echo -n -e "Finished $NUM of $COUNT_SIMS sims         \033[1G"
    SIM_FIN=`cat $DIR/sim_finish | wc -l`
    let SIM_DIFF=SIM_RUN-SIM_FIN
  done

done

while [ $SIM_DIFF -ne 0 ]; do
    sleep 5
    echo -n -e "Finished $SIM_FIN of $COUNT_SIMS sims         \033[1G"
    SIM_FIN=`cat $DIR/sim_finish | wc -l`
    let SIM_DIFF=SIM_RUN-SIM_FIN
done

rm -f $DIR/sim_finish $DIR/sim_run
