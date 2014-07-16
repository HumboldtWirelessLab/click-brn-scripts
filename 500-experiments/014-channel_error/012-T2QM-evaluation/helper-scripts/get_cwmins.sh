#!/bin/bash

if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

NODES=`cat $DIR/nodes.mac | awk '{print $3}' | grep -v "\-01"`

SIM_DUR=60

#echo -e "sec\tcwmin"

for sec in `seq 1 $SIM_DUR`; do

	echo -en "$sec\t"

	for node in $NODES; do
		NODE_CWMIN=`bzcat $DIR/measurement.log.bz2 |\
		     grep "new bo:" |\
		     grep " $sec\." |\
		     grep $node |\
		     awk '{print $6}'`

		if [ "x$NODE_CWMIN" != "x128" ]; then
			if [ "x$NODE_CWMIN" != "x256" ]; then
				NODE_CWMIN="-"
			fi
		fi

		echo -en "$NODE_CWMIN\t"
	done

	echo ""
done

NUM_NODES=`echo $NODES | wc -w`

for i in `seq 1 $NUM_NODES`; do
	for j in `seq 1 8`; do
		echo -n "-"
	done
done

echo ""
