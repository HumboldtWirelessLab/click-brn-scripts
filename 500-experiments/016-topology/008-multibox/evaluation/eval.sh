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


#
# Check bridges
#
xsltproc -o ${RESULTDIR}/measurement.postxslt ${DIR}/../../common_evaluation/strip.xslt ${RESULTDIR}/measurement.xml

BR_FOUND=$(grep ${RESULTDIR}/measurement.postxslt -e "^bridges.*")
BR_EXPECTED=""
if [ "${BR_FOUND}" != "${BR_EXPECTED}" ]; then
  echo "Failed: Bridge analysis"
  echo "  Found:   ${BR_FOUND}"
  echo "  Expected:${BR_EXPECTED}"
  exit -1
fi


#
# Check APs
# 
AP_FOUND=$(grep ${RESULTDIR}/measurement.postxslt -e "^articulationpoints.*")
AP_EXPECTED=""
if [ "${AP_FOUND}" != "${AP_EXPECTED}" ]; then
  echo "Failed: Articulation point analysis"
  echo "  Found:   ${AP_FOUND}"
  echo "  Expected:${AP_EXPECTED}"
  exit -1
fi


echo "Result: OK"
exit 2
