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

LINKS_PATH=${RESULTDIR}/links.csv
ETXLIMIT=100


cd ${RESULTDIR}
../../common_evaluation/calc_articulation_points.R ${LINKS_PATH} ${ETXLIMIT} > ${RESULTDIR}/theoretical_articulation_points.csv
../../common_evaluation/calc_bridges.R ${LINKS_PATH} ${ETXLIMIT} > ${RESULTDIR}/theoretical_bridges.csv
../../common_evaluation/calc_f1_measure.R

# colision stat 
COL_PATH=collisions.csv
grep -e "COL" simpleflow.tr | awk -F " " 'BEGIN{print "\"time\", \"node\""} {printf "%f,sk%d\n",$2,$3+1  }' > ${COL_PATH}
../../common_evaluation/plot_collisions.R

echo "Done"
exit 2

