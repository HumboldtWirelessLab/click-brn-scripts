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
ETXLIMIT=$2
export ETXLIMIT
TRAVERSALTIME_MIN="4"
TRAVERSALTIME_MAX="120"
TRAVERSALTIME_STEP="4"


echo "simulate ${RUNS} runs"
if [ "x${ETXLIMIT}" == "x" ]
then
	echo "don't use ETX-metric limit"
else
	echo "use ETX-metric limit max(${ETXLIMIT})"
fi
read -p "Do you want start a test with these settings?   ....(Ctrl+C to abort)"


for RUN in $(seq ${RUNS})
do
	#
	# Create NPart placement
	#
	echo "create NPart placement..."
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
	
	
	for TRAVERSALTIME in $(seq ${TRAVERSALTIME_MIN} ${TRAVERSALTIME_STEP} ${TRAVERSALTIME_MAX})
	do
		#
		# Set current value 
		#
		sed -i  "s/MAX_TRAVERSAL_TIME_MS [0-9]*/MAX_TRAVERSAL_TIME_MS ${TRAVERSALTIME}/" simpleflow.click

		#
		# Get result dir
		#
		i=1
		while [ -e "./$i" ]; do i=$((i+1)); done;
		SIM_RESULT_DIR=${i}
		echo "next simulation result dir: ${SIM_RESULT_DIR}"
		
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
		rm -rf ${SIM_RESULT_DIR}/*.{nam,tr,eth0,log,xml,sh,pdf,ns2,tcp,stats}

		#
		# Copy
		#
		DES="${TRAVERSALTIME}-traversal"
		if [ ! -d "${DES}" ]
		then
			mkdir "${DES}"
		fi

		i=1
		while [ -e "./${DES}/$i" ]; do i=$((i+1)); done;
		DES_SIM_RESULT_DIR=${DES}/${i}

		echo "move ${SIM_RESULT_DIR} to ${DES_SIM_RESULT_DIR}"
		mv ${SIM_RESULT_DIR} ${DES_SIM_RESULT_DIR}

	done
done

#
# Process results
#
echo "process results..."
for TRAVERSALTIME in $(seq ${TRAVERSALTIME_MIN} ${TRAVERSALTIME_STEP} ${TRAVERSALTIME_MAX})
do
	#
	# get dir
	#
	DES="${TRAVERSALTIME}-traversal"
	
	echo "Process ${DES}"
	cd ${DES}
	../../common_evaluation/collect_results.sh > ${RESULT_PATH}
	cd ..

done

echo "Done"
