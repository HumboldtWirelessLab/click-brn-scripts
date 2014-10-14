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
DISTANCE_MIN="100"
DISTANCE_MAX="400"
DISTANCE_STEP="10"


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
	for DISTANCE in $(seq ${DISTANCE_MIN} ${DISTANCE_STEP} ${DISTANCE_MAX})
	do
		
		echo "------------------[ Run ${RUN}/${RUNS} ]------[ ${DISTANCE} ]------------------"

		#
		# Create placement
		#
		echo "create box placement..."
		let FIRST=50
		let SECOND=${DISTANCE}-${FIRST}
		../common_evaluation/generate_box_placement.R --l1 ${FIRST} --l2 ${SECOND} --b 300 --r1 ${FIRST} --r2 ${SECOND} > ${PLACEMENT_PATH}
		if [ "$?" -ne 0 ] 
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
		DES="${DISTANCE}-quali"
		if [ ! -d "${DES}" ]
		then
			mkdir "${DES}"
		fi

		i=1
		while [ -e "./${DES}/$i" ]; do i=$((i+1)); done;
		DES_SIM_RESULT_DIR=${DES}/${i}

		echo "move ${SIM_RESULT_DIR} to ${DES_SIM_RESULT_DIR}"
		mv ${SIM_RESULT_DIR} ${DES_SIM_RESULT_DIR}
		cp ${PLACEMENT_PATH} ${DES_SIM_RESULT_DIR}

	done
done

#
# Process results
#
echo "process results..."
for DISTANCE in $(seq ${DISTANCE_MIN} ${DISTANCE_STEP} ${DISTANCE_MAX})
do
	#
	# get dir
	#
	DES="${DISTANCE}-quali"	
	echo "Process ${DES}"
	cd ${DES}
	../../common_evaluation/collect_results.sh > ${RESULT_PATH}
	cd ..
done

echo "Done"
