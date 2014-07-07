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

xsltproc -o ${RESULTDIR}/input_dataset.xml ${RESULTDIR}/../../common_evaluation/input_neurons.xslt ${RESULTDIR}/measurement.xml 

echo "Result: xsltproc returned $?"

exit 2

