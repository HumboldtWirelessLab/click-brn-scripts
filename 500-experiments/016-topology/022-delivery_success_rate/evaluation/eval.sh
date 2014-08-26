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

xsltproc ${DIR}/string_placement_to_csv.xslt ${RESULTDIR}/measurement.xml >  ${RESULTDIR}/result.csv
cd ${RESULTDIR}
Rscript ../evaluation/plot.R

echo "Done"
exit 2

