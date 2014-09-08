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

echo -n "" > backoffusage.mat
echo -n "" > bovalues.mat
echo -n "" > backoffperformance.mat

for i in `ls -d ../[0-9]*`; do

  . $i/params

  PARAMS=`cat $i/params_string`

  #cat $i/evaluation/backoffusage.mat | awk -v params="$PARAMS" '{print params" "$0}' >> backoffusage.mat
  #cat $i/evaluation/bovalues.mat | awk -v params="$PARAMS" '{print params" "$0}' >> bovalues.mat

  RES=`cat $i/evaluation/result.mat`

  echo "$PARAMS $RES" >> backoffperformance.mat

done

#(cd $DIR;  matwrapper.sh "try,backoff_eval,catch,exit(1),end,exit(0)" 1> /dev/null)
(cd $DIR;  matwrapper.sh "try,backoff_bestbo,catch,exit(1),end,exit(0)" 1> /dev/null)

exit 0
