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
$DIR/extract_nodes.py -p ${RESULTDIR}


#
# Create links.csv
# Create articulation_points.csv
# Create runs.csv
# Create bridges.csv
#

LINKS_PATH=${RESULTDIR}/links.csv
PRE_LINKS_PATH=${RESULTDIR}/links_extract.xml
${DIR}/extract_dibadawn_links.py -f ${RESULTDIR}/measurement.xml > ${PRE_LINKS_PATH}
xsltproc -o ${LINKS_PATH} ${DIR}/dibadawn_links_to_csv.xslt ${PRE_LINKS_PATH}

SEARCHES=${RESULTDIR}/searches.xml
TOPO_PATH=${RESULTDIR}/topo_info.xml
$DIR/extract_topology_info.py -f ${RESULTDIR}/measurement.xml > ${TOPO_PATH}
xsltproc -o ${SEARCHES} ${DIR}/group_searches.xslt ${TOPO_PATH}

xsltproc -o ${RESULTDIR}/articulation_points.csv ${DIR}/dibadawn_articulation_points.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/bridges_all.csv ${DIR}/dibadawn_all_bridges.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/bridges_unique_per_search.csv ${DIR}/dibadawn_unique_bridges_per_search.xslt ${SEARCHES}

# Count runs
COUNT_OF_RUNS=$(grep -e "^<DibadawnStartSearch" ${RESULTDIR}/measurement.xml | wc -l)
echo -e "\"num_of_runs\"\n${COUNT_OF_RUNS}" > ${RESULTDIR}/runs.csv

xsltproc -o ${RESULTDIR}/cycles.csv ${DIR}/dibadawn_asym_cycle_ration.xslt ${RESULTDIR}/measurement.xml
 
cd ${RESULTDIR}
../../common_evaluation/calc_articulation_points.R ${LINKS_PATH} ${ETXLIMIT} > ${RESULTDIR}/theoretical_articulation_points.csv
../../common_evaluation/calc_bridges.R ${LINKS_PATH} ${ETXLIMIT} > ${RESULTDIR}/theoretical_bridges.csv
../../common_evaluation/calc_f1_measure.R

exit 2

