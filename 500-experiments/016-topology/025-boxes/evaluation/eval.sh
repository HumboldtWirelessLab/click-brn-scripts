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

PRE_LINKS_PATH=${RESULTDIR}/links_filtered_orig.csv
LINKS_PATH=${RESULTDIR}/links_filtered.csv
ETXLIMIT=100

cd ${RESULTDIR}

../../common_evaluation/filter_links.py -f ${RESULTDIR}/links_raw.csv -e ${ETXLIMIT} > ${PRE_LINKS_PATH}

grep -e "00-01.*00-02" -e "00-02.*00-01" -e "node_a" ${PRE_LINKS_PATH} > ${LINKS_PATH}

../../common_evaluation/calc_articulation_points.R ${LINKS_PATH} > ${RESULTDIR}/theoretical_articulation_points.csv
../../common_evaluation/calc_bridges.R ${LINKS_PATH} > ${RESULTDIR}/theoretical_bridges.csv
../../common_evaluation/calc_f1_measure.R

echo "Done"
exit 2

