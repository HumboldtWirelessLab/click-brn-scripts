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

for i in `seq 0 8`; do
#  (cd PARAMS_$i/1/; rm -rf evaluation; sh ./eval_again.sh)
  (cd PARAMS_$i/1/; sh ./eval_again.sh)
done
