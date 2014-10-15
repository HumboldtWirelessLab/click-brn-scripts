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

../../common_evaluation/extract_nodes.py -p ${RESULTDIR}

LINKS_EXTRACED_PATH=${RESULTDIR}/links_extract.xml
../../common_evaluation/extract_dibadawn_links.py -f ${RESULTDIR}/measurement.xml > ${LINKS_EXTRACED_PATH}
LINKS_RAW_PATH=${RESULTDIR}/links_raw.csv
xsltproc -o ${LINKS_RAW_PATH} ../../common_evaluation/dibadawn_links_to_csv.xslt ${LINKS_EXTRACED_PATH}
../../common_evaluation/filter_links.py -f ${RESULTDIR}/links_raw.csv -e ${ETXLIMIT} > ${PRE_LINKS_PATH}

grep -e "00-01.*00-02" -e "00-02.*00-01" -e "node_a" ${PRE_LINKS_PATH} > ${LINKS_PATH}

SEARCHES=${RESULTDIR}/searches.xml
TOPO_PATH=${RESULTDIR}/topo_info.xml
../../common_evaluation/extract_topology_info.py -f ${RESULTDIR}/measurement.xml > ${TOPO_PATH}
xsltproc -o ${SEARCHES} ../../common_evaluation/group_searches.xslt ${TOPO_PATH}

xsltproc -o ${RESULTDIR}/articulation_points.csv ../../common_evaluation/dibadawn_articulation_points.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/bridges_all.csv ../../common_evaluation/dibadawn_all_bridges.xslt ${SEARCHES}
xsltproc -o ${RESULTDIR}/bridges_unique_per_search.csv ../../common_evaluation/dibadawn_unique_bridges_per_search.xslt ${SEARCHES}

# Count runs
COUNT_OF_RUNS=$(grep -e "^<DibadawnStartSearch" ${RESULTDIR}/measurement.xml | wc -l)
echo -e "\"num_of_runs\"\n${COUNT_OF_RUNS}" > ${RESULTDIR}/runs.csv

# Count measure
COUNT_OF_MEASURES=$(grep -e "topology_info.*extra_data=" ${RESULTDIR}/measurement.xml | awk -F "'" 'BEGIN{max=0}{if($6 > max){max = $6}}END{print max}')
echo -e "\"num_of_measure\"\n${COUNT_OF_MEASURES}" > ${RESULTDIR}/runs_measure.csv

../../common_evaluation/calc_articulation_points.R ${LINKS_PATH} > ${RESULTDIR}/theoretical_articulation_points.csv
../../common_evaluation/calc_bridges.R ${LINKS_PATH} > ${RESULTDIR}/theoretical_bridges.csv
../../common_evaluation/calc_f1_measure.R

echo "Done"
exit 2