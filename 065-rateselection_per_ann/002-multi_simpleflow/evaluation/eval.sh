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

xsltproc -o ${RESULTDIR}/measurement.postxslt ${DIR}/input_neurons.xslt ${RESULTDIR}/measurement.xml 

echo "Mein Result: xsltproc returned $?"

exit 2

