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
xsltproc -o ${RESULTDIR}/links.csv ${DIR}/../../common_evaluation/extract_links.xslt ${RESULTDIR}/measurement.xml 
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
# Check bridges
#
BR_FOUND=$(grep ${RESULTDIR}/measurement.postxslt -e "^bridges.*")
BR_EXPECTED="bridges,00-00-00-00-00-03--00-00-00-00-00-02,00-00-00-00-00-02--00-00-00-00-00-01,00-00-00-00-00-05--00-00-00-00-00-04,00-00-00-00-00-04--00-00-00-00-00-03,00-00-00-00-00-05--00-00-00-00-00-04,00-00-00-00-00-04--00-00-00-00-00-03,00-00-00-00-00-03--00-00-00-00-00-02,00-00-00-00-00-02--00-00-00-00-00-01,"
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
AP_EXPECTED="articulationpoints,00-00-00-00-00-02,00-00-00-00-00-04,00-00-00-00-00-03,"
if [ "${AP_FOUND}" != "${AP_EXPECTED}" ]; then
  echo "Failed: Articulation point analysis"
  echo "  Found:   ${AP_FOUND}"
  echo "  Expected:${AP_EXPECTED}"
  exit -1
fi


echo "Result: Success"
exit 2
