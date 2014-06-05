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
# Copy missing plm file
#
if [ ! -f ${RESULTDIR}/"placementfile.plm" ]; then
  echo "Info: Copy placement file..."
  echo "      ... From ${RESULTDIR}/../placementfile.plm"
  echo "      ... to ${RESULTDIR}/placementfile.plm"
  cp ${RESULTDIR}/../placementfile.plm ${RESULTDIR}/placementfile.plm
fi


#
# Check bridges
#
xsltproc -o ${RESULTDIR}/measurement.postxslt ${DIR}/strip.xslt ${RESULTDIR}/measurement.xml 

BR_FOUND=$(grep ${RESULTDIR}/measurement.postxslt -e "^bridges.*")
BR_EXPECTED="bridges,00-00-00-00-00-01--00-00-00-00-00-05,00-00-00-00-00-05--00-00-00-00-00-01,"
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
AP_EXPECTED="articulationpoints,00-00-00-00-00-05,"
if [ "${AP_FOUND}" != "${AP_EXPECTED}" ]; then
  echo "Failed: Articulation point analysis"
  echo "  Found:   ${AP_FOUND}"
  echo "  Expected:${AP_EXPECTED}"
  exit -1
fi

echo "OK"
exit 2

