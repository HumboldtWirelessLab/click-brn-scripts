#!/bin/bash
# Author: kuehne@informatik.hu-berlin.de
# Function: Stream-Test; Program checks if throughput passes threshold to be valid.
# Return:
#			exit 0: ok
#			exit 1:
#			exit 2: throughput too small
 


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
mac=`cat $RESULTDIR/nodes.mac | grep ${nodes[$send_id]} | awk '{ print $3; }' | sed s/:/-/g`
pkt_recv=`fromdump.sh $RESULTDIR/$DUMP_FILE | grep $mac | wc -l`


# eval pdr
pdr=`expr $pkt_recv \* 100 / \( $TIME \* 10 \)`
if [ $pdr -gt 50 ]; then
	echo "PDR seems okay  (PDR=$pdr/100)."
	exit 0
else 
	echo "PDR too small (PDR=$pdr/100)."
	exit 2
fi

