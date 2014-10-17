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

LINKS_PATH=${RESULTDIR}/links_filtered.csv
ETXLIMIT=10


cd ${RESULTDIR}

../../common_evaluation/filter_links.py -f ${RESULTDIR}/links_raw.csv -e ${ETXLIMIT} > ${LINKS_PATH}

../../common_evaluation/calc_articulation_points.R ${LINKS_PATH} > ${RESULTDIR}/theoretical_articulation_points.csv
../../common_evaluation/calc_bridges.R ${LINKS_PATH} > ${RESULTDIR}/theoretical_bridges.csv
../../common_evaluation/calc_f1_measure.R

echo "Done"
exit 2

