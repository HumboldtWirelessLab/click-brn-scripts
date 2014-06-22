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

xsltproc -o ${RESULTDIR}/measurement.postxslt ${DIR}/strip.xslt ${RESULTDIR}/measurement.xml 
RESULT=`grep ${RESULTDIR}/measurement.postxslt -e "^result" | awk -F, '{ if($2==1 && $3==1) {print "Success"; } else {print "Failed"}}'`

echo "Mein Result: ${RESULT}"

exit 2

