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
if [ "$?" -ne 0 ]
then
  echo "Failed to extract nodes.csv"
  exit -1
fi

#
# Create links.scv
#
PRE_LINKS_PATH=${RESULTDIR}/links_extract.xml
LINKS_PATH=${RESULTDIR}/links.csv
xsltproc -o ${PRE_LINKS_PATH} ${DIR}/../../common_evaluation/extract_dibadawn_links.xslt ${RESULTDIR}/measurement.xml 
xsltproc -o ${LINKS_PATH} ${DIR}/../../common_evaluation/dibadawn_links_to_csv.xslt ${PRE_LINKS_PATH}
if [ "$?" -ne 0 ]
then
  echo "Failed to extract links.csv"
  exit -1
fi


#
# Extract DIBADAWN results
#
xsltproc -o ${RESULTDIR}/measurement.postxslt ${DIR}/../../common_evaluation/strip.xslt ${RESULTDIR}/measurement.xml 
if [ "$?" -ne 0 ]
then
  echo "Failed to extract DIBADAWN results"
  exit -1
fi


#
# Check number of timeouts
# 
TO_FOUND=$( awk -F ',' '{ if($1 == "result") { num_of_timeouts= $6; print num_of_timeouts}}' ${RESULTDIR}/measurement.postxslt)
TO_EXPECTED="1"
if [ "${TO_FOUND}" != "${TO_EXPECTED}" ]; then
  echo "Failed: Number of timeout analysis"
  echo "  Found:   ${TO_FOUND}"
  echo "  Expected:${TO_EXPECTED}"
  exit -1
fi


echo "Result: Success"
exit 2
