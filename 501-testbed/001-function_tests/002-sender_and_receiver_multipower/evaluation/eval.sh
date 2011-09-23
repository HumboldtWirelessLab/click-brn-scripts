#!/bin/bash
# Author: kuehne@informatik.hu-berlin.de
# Function: Stream-Test; checks throughput under different power rates.

. $CONFIGFILE



# Get dump-file
DUMP_FILE=`ls -1 "$RESULTDIR" | grep dump`

# check for sender or receiver role
nodes[0]=`sed -n 1p "$RESULTDIR/nodes.mac" | awk '{ print $1; }'`
nodes[1]=`sed -n 2p "$RESULTDIR/nodes.mac" | awk '{ print $1; }'`

cmd=`grep "${nodes[0]}" "$NODETABLE" | grep -v "#${nodes[0]}"  |  awk '{ print $7; }'`
if [ "x$cmd" = "xsender.click" ]; then
	send_id=0
else
	send_id=1
fi

# sum up received packets
mac=`cat $RESULTDIR/nodes.mac | \
	grep ${nodes[$send_id]} | \
	awk '{ print $3; }' | \
	sed s/:/-/g`


# todo: anpassung der total-werte an die verschiedenen phasen;
# in dieser form nicht korrekt
total=`fromdump.sh $RESULTDIR/$DUMP_FILE | \
		grep $mac | \
		wc -l`
		
threshold=50

for ((step=0; step<100; step+=20, range=20))
do
	pkt_recv=`fromdump.sh $RESULTDIR/$DUMP_FILE | \
		grep $mac | \
		awk -v step=$step -v range=$range \
			'	
				{x=substr($2,0,(length($2)-1));}  	# stupid hack: cut ":" as last position
				step<x && x<(step+range) {print $1;} 		# check if in valid time range
			' | \
		wc -l`

	# eval pdr
	pdr=`expr $pkt_recv \* 100 / \( $total  \)`
	if [ $pdr -gt $threshold ] && [ $pdr -le 100 ]; then
		echo "PDR seems okay  (PDR=$pdr/100)."
		#exit 0
	elif [ $pdr -ge 0 ] && [ $pdr -le $threshold ]; then
		echo "PDR too small (PDR=$pdr/100)."
		#exit 2
	else
		echo "Something fu** up!"
	fi
done
