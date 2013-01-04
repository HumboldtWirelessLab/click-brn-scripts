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

for i in `ls -d *MBit*`; do
#  (cd  $i/; rm -rf evaluation; ADDEVALUATION="evaluation/eval.sh linkstat_graph network_info flooding_info flow_info" sh ./eval_again.sh)
  (cd  $i/; rm -rf evaluation; ADDEVALUATION="evaluation/eval.sh network_info flooding_info flow_info" sh ./eval_again.sh)
#  (cd  $i/; ADDEVALUATION="status_compression" sh ./eval_again.sh)
done
