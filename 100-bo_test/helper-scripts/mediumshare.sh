#!/bin/bash

SIM_DUR=`sh helper-scripts/get_simdur.sh`
RES_FILE="ms.mat"
EVAL_DIR="evaluation"
NUM_NODES=3
MACS="00-02 00-04 00-06"

# get sim dir
if [ "x$1" == "x" ]; then
	DIR=1
else
	DIR=$1
fi

RES_FILE="ms-$DIR.mat"

# reset result file
if [ -e $EVAL_DIR/$RES_FILE ]; then
	rm -f $EVAL_DIR/$RES_FILE
fi

for sec in `seq 2 $SIM_DUR`; do

	MS_TUPLE=""

	for node in $MACS; do

		MS=`cat $DIR/measurement.log |\
		           grep "tx:" |\
		           grep " $sec\." |\
		           grep "$node" |\
		           awk '{printf "%d ", $5 }'`

		if [ "x$MS" = "x" ]; then
			MS="0 "
		fi

		MS_TUPLE=$MS_TUPLE$MS
	done

	echo $MS_TUPLE >> $RES_FILE
	echo "" >> $RES_FILE
done

mv $RES_FILE $EVAL_DIR

