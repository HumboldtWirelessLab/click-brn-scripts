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
$DIR/../bin/extract_nodes.py -p ${RESULTDIR}


#
# Create links.csv
# Create articulation_points.csv
# Create runs.csv
# Create bridges.csv
#
PRE_LINKS_PATH=${RESULTDIR}/links_extract.xml
LINKS_PATH=${RESULTDIR}/links.csv
SEARCHES=${RESULTDIR}/searches.xml
${DIR}/extract_dibadawn_links.py -f ${RESULTDIR}/measurement.xml > ${PRE_LINKS_PATH}
xsltproc -o ${LINKS_PATH} ${DIR}/dibadawn_links_to_csv.xslt ${PRE_LINKS_PATH}
xsltproc -o ${SEARCHES} ${DIR}/group_searches.xslt ${RESULTDIR}/measurement.xml 
xsltproc -o ${RESULTDIR}/articulation_points.csv ${DIR}/dibadawn_articulation_points.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/bridges_all.csv ${DIR}/dibadawn_all_bridges.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/bridges_unique_per_search.csv ${DIR}/dibadawn_unique_bridges_per_search.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/runs.csv ${DIR}/dibadawn_runs.xslt ${RESULTDIR}/measurement.xml
xsltproc -o ${RESULTDIR}/cycles.csv ${DIR}/dibadawn_asym_cycle_ration.xslt ${RESULTDIR}/measurement.xml
 

cd ${RESULTDIR}
../../common_evaluation/calc_articulation_points.R ${LINKS_PATH} ${ETXLIMIT} > ${RESULTDIR}/theoretical_articulation_points.csv
../../common_evaluation/calc_bridges.R ${LINKS_PATH} ${ETXLIMIT} > ${RESULTDIR}/theoretical_bridges.csv
../../common_evaluation/calc_f1_measure.R


exit 2

