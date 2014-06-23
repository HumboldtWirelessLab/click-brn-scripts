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

#
# Create nodes.csv
#
$DIR/../../bin/extract_nodes.py -p ${RESULTDIR}


#
# Create links.scv
#
xsltproc -o ${RESULTDIR}/links.csv ${DIR}/../../common_evaluation/extract_links.xslt ${RESULTDIR}/measurement.xml 


PYTHONPATH=$DIR/../../lib/
export PYTHONPATH
$DIR/eval.py
echo "Mein Result: $?"

exit 2

