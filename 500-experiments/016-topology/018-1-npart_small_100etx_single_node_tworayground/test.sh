#!/bin/bash

if [ $# -le 0 ]
then
	echo "usage: $0 number_of_runs"
	exit -1
fi

# Settings
PLACEMENT_PATH="placementfile.plm"
RESULT_PATH="test-result.csv"
RUNS=$1


echo "overwrite placement file ${PLACEMENT_PATH}"
echo "overwrite result file ${RESULT_PATH}"
echo "simulate ${RUNS} runs"
read -p "Do you want start a test with these settings?   ....(Ctrl+C to abort)"


for RUN in $(seq ${RUNS})
do
	i=1
	while [ -e "./$i" ]; do i=$((i+1)); done;
	SIM_RESULT_DIR=${i}
	echo "next simulation result dir: ${SIM_RESULT_DIR}"

	#
	# Create NPart placement
	#
	echo "create NPart placement..."
	echo "  output file: ${PLACEMENT_PATH}"
	OPWD=$(pwd)
	cd ../../../../helper/src/Npart
	NUM_OF_NODES=175
	RXRANGE=400  ./gen_topo.sh ${NUM_OF_NODES}  2>/dev/null > /tmp/${PLACEMENT_PATH}
	RESULT=$?
	cd ${OPWD}
	cat /tmp/${PLACEMENT_PATH} | awk -F " " '{print "sk"NR,$2,$3,$4}' > ${PLACEMENT_PATH}
	
	if [ "${RESULT}" -ne 0 ] 
	then
		echo "result: failed"
		exit -1
	fi
	
	
	#
	# Update mes
	#
	echo "update .mes file..."
	NODE_COUNT=$(wc -l ${PLACEMENT_PATH} | awk -F " " '{ print $1}')
	echo "  new node count: ${NODE_COUNT}"
	sed -i "s/:[0-9]*/:${NODE_COUNT}/" simpleflow.mes
	if [ "$?" -ne 0 ] 
	then
		echo "result: failed"
		exit -1
	fi
	
	#
	# simulate placement
	#
	echo "run simulation..."
	USEPYTHON=1 PROGRESS=1  run_sim.sh
	RESULT=$?
	if [ "${RESULT}" -ne 0 ] 
	then
		echo "result: failed"
		exit -1
	fi

	#
	# Remove large files
	#
	rm -rf ${SIM_RESULT_DIR}/*.nam ${SIM_RESULT_DIR}/*.tr
done

#
# Process results
#
echo "process results..."
echo "  ...write ${RESULT_PATH}"
../common_evaluation/collect_results.sh > ${RESULT_PATH}

echo "Done"