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

# colision stat 
grep -e "COL" simpleflow.tr | awk -F " " 'BEGIN{print "\"time\", \"node\""} {printf "%f,sk%d\n",$2,$3+1  }' > collisions.csv
../../common_evaluation/plot_collisions.R

# asym. crossedge
grep -e "<CrossEdgeDetected.*valid='0'" measurement.xml | awk -F "'" 'BEGIN{print "\"time\", \"nodeA\", \"nodeB\", \"searchId\""} {printf "%s,%s,%s,%s\n",$6,$2,$4,$8  }' > asym_crossedges.csv
../../common_evaluation/plot_asym_crossedges.R

echo "Done"
exit 2

