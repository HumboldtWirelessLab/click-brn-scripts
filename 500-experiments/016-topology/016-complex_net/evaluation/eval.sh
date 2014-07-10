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
# Create links.csv
# Create articulation_points.csv
# Create runs.csv
# Create bridges.csv
#
PRE_LINKS_PATH=${RESULTDIR}/links_extract.xml
LINKS_PATH=${RESULTDIR}/links.csv
SEARCHES=${RESULTDIR}/searches.xml
xsltproc -o ${PRE_LINKS_PATH} ${DIR}/../../common_evaluation/extract_dibadawn_links.xslt ${RESULTDIR}/measurement.xml 
xsltproc -o ${LINKS_PATH} ${DIR}/../../common_evaluation/dibadawn_links_to_csv.xslt ${PRE_LINKS_PATH}
xsltproc -o ${SEARCHES} ${DIR}/../../common_evaluation/group_searches.xslt ${RESULTDIR}/measurement.xml 
xsltproc -o ${RESULTDIR}/articulation_points.csv ${DIR}/../../common_evaluation/dibadawn_articulation_points.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/bridges_all.csv ${DIR}/../../common_evaluation/dibadawn_all_bridges.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/bridges_unique_per_search.csv ${DIR}/../../common_evaluation/dibadawn_unique_bridges_per_search.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/runs.csv ${DIR}/../../common_evaluation/dibadawn_runs.xslt ${RESULTDIR}/measurement.xml


cd ${RESULTDIR}
../../common_evaluation/calc_articulation_points.R ${LINKS_PATH} ${ETXLIMIT} > ${RESULTDIR}/theoretical_articulation_points.csv
../../common_evaluation/calc_bridges.R ${LINKS_PATH} ${ETXLIMIT} > ${RESULTDIR}/theoretical_bridges.csv
../../common_evaluation/calc_f1_measure.R


echo "Done"
exit 2

