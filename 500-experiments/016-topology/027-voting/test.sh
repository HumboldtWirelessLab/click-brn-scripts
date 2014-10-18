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
RULE_MIN=1
RULE_MAX=7

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
	NODE_COUNT=$(wc -l ${PLACEMENT_PATH} | awk -F " " '{ print $1}')
	echo "  new node count: ${NODE_COUNT}"
	
	if [ "${RESULT}" -ne 0 ] 
	then
		echo "result: failed"
		exit -1
	fi
	
	
	for ETX in 10 100
	do
		echo "update etx threshold at DES file"
		sed -ie "s/ETX_THRESHOLD=[0-9]*/ETX_THRESHOLD=${ETX}/" simpleflow.des 

		for RULE in $(seq ${RULE_MIN} ${RULE_MAX})
		do
			echo "------------------[ Run ${RUN}/${RUNS} ]------[ Rule ${RULE}/${RULE_MAX} ]-----[ ETX $ETX ]-------------"

			#
			# Update click
			#
			echo "update voting rule at CLICK file"
			sed -i  "s/VOTING_RULE [0-9]*/VOTING_RULE ${RULE}/" simpleflow.click

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
			# Get or update net info for next rules
			#
			if [ ! -n "${PROBABILITY_BR}" ]
			then
				PROBABILITY_BR=$(awk -F ',' '{if($1 == "probability_theo_br"){ print $2}}' ${SIM_RESULT_DIR}/result.csv)
				echo "update bridge probability ${PROBABILITY_BR}"
				sed -ie "s/BR_POBABILITY [0-9]*\.[0-9]*/BR_POBABILITY ${PROBABILITY_BR}/" simpleflow.click 
			fi
			
			if [ ! -n "${PROBABILITY_AP}" ]
			then
				PROBABILITY_AP=$(awk -F ',' '{if($1 == "probability_theo_ap"){ print $2}}' ${SIM_RESULT_DIR}/result.csv)
				echo "update AP probability ${PROBABILITY_AP}"
				sed -ie "s/AP_POBABILITY [0-9]*\.[0-9]*/AP_POBABILITY ${PROBABILITY_AP}/" simpleflow.click
			fi

			#
			# Remove large files
			#
			rm -rf ${SIM_RESULT_DIR}/*.{nam,tr,eth0,log,xml,sh,pdf,ns2,tcp,stats}

			#
			# Copy
			#
			DES="${RULE}-votingrule"
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

		unset PROBABILITY_BR
		unset PROBABILITY_AP

	done
done

#
# Process results
#
#
for RULE in $(seq ${RULE_MIN} ${RULE_MAX})
do
	# get dir
	#
	DES="${RULE}-votingrule"
	
	echo "Process ${DES}"
	cd ${DES}
	../../common_evaluation/collect_results.sh > ${RESULT_PATH}
	cd ..
done

echo "Done"