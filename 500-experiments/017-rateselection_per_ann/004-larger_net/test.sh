#!/bin/bash

if [ $# -le 0 ]
then
	echo "usage: $0 number_of_runs"
	exit -1
fi

# Settings
PLACEMENT_PATH="placementfile.plm"
RESULT_PATH="input_dataset.xml"
RUNS=$1
export ETXLIMIT


echo "overwrite placement file ${PLACEMENT_PATH}"
echo "overwrite result file ${RESULT_PATH}"
echo "simulate ${RUNS} runs"
echo ""
read -p "Do you want start a test with these settings?   ....(Ctrl+C to abort)"


for RUN in $(seq ${RUNS})
do
	if [ "x${USENPART}" != "x" ]
	then
		#
		# Create NPart placement
		#
		echo "create NPart placement..."
		echo "  output file: ${PLACEMENT_PATH}"
		OPWD=$(pwd)
		cd ../../../../helper/src/Npart
		EXPECT_NUM_OF_NODES=80
		RXRANGE=230  ./gen_topo.sh ${EXPECT_NUM_OF_NODES}  2>/dev/null > /tmp/${PLACEMENT_PATH}
		RESULT=$?
		cd ${OPWD}
		cat /tmp/${PLACEMENT_PATH} | awk -F " " '{print "sk"NR,$2,$3,$4}' > ${PLACEMENT_PATH}
		
		if [ "${RESULT}" -ne 0 ] 
		then
			echo "result: failed"
			exit -1
		fi
	
		#
		#
		#
		NODE_COUNT=$(wc -l ${PLACEMENT_PATH} | awk -F " " '{ print $1}')
		echo "  new node count: ${NODE_COUNT}"
			
	
		#
		#
		#
		echo "update .mes file..."
		mv simpleflow.mes simpleflow-orig.mes
		cat simpleflow-orig.mes | sed "s/:[0-9]*/:${NODE_COUNT}/" > simpleflow.mes
		if [ "$?" -ne 0 ] 
		then
			echo "result: failed"
			exit -1
		fi
	else
		#
		#
		#
		NODE_COUNT=$(grep -oPe ":\K\w+" simpleflow.mes)
		echo "  current node count: ${NODE_COUNT}"
	fi

	for LOAD_MBITS in 22000000 16500000 11000000 5500000 2000000; do

		#
		#
		#
		echo "update ctl file..."
		echo "  net load: ${LOAD_MBITS} Mbits/sec"
		./generate_ctl.py --nodes ${NODE_COUNT} --load ${LOAD_MBITS} > simpleflow.ctl
		if [ "$?" -ne 0 ] 
		then
			echo "result: failed"
			exit -1
		fi
			
	
		#
		#
		#
		echo "update simulation duration..."
		TIME_OF_LAST_CTL_ENTRY=$(tail -n 30 simpleflow.ctl | awk  '{if(NF > 1){last_time = $1}} END{print last_time}')
		SIM_DURATION=$( expr ${TIME_OF_LAST_CTL_ENTRY} + 10 )
		echo "  new duration: ${SIM_DURATION}"
		sed --in-place=".orig" "s/^TIME=.*/TIME=${SIM_DURATION}/" simpleflow.des
	
	
		#
		#
		#
		echo "run simulation..."
		PROGRESS=1 USEPYTHON=1 run_sim.sh
		RESULT=$?
		if [ "${RESULT}" -ne 0 ] 
		then
			echo "result: failed"
			exit -1
		fi
	
	done

done

#
# Process results
#
echo "process results..."
echo "  ...write ${RESULT_PATH}"
echo "<?xml version="1.0"?>\n<data_set>" > ${RESULT_PATH}
cat [0-9]*/input_dataset.xml | tail -n +3 | head -n-1 >> ${RESULT_PATH}
echo "</data_set>" >> ${RESULT_PATH}

echo "Done"
