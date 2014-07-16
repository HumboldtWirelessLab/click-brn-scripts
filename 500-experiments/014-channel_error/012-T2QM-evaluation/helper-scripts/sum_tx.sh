#!/bin/bash

if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

NODES=`cat $DIR/nodes.mac | awk '{print $3}' | grep -v "\-01"`

SIM_DUR=30


echo -e "sec\tsum"

for sec in `seq 1 $SIM_DUR`; do
	SUM=0

	for node in $NODES; do
		NODE_TX=`bzcat $DIR/measurement.log.bz2 |\
		     grep -v "target" |\
		     grep "tx:" |\
		     grep $node |\
		     grep " $sec\." |\
		     awk '{print $5}'`

		let SUM=SUM+NODE_TX
	done

	echo -e "$sec\t$SUM"
done
