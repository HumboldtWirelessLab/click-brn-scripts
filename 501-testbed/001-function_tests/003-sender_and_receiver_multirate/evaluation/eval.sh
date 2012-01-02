#!/bin/bash
# Author: kuehne@informatik.hu-berlin.de
# Function: Stream-Test; Test the rate selection 
# Return:
#			exit 0: ok
#			exit 1:
#			exit 2: throughput too small
 


. $CONFIGFILE



# Get dump-file
DUMP_FILE=`ls -1 "$RESULTDIR" | grep "raw.dump"`

# check for sender or receiver role
nodes[0]=`sed -n 1p "$RESULTDIR/nodes.mac" | awk '{ print $1; }'`
nodes[1]=`sed -n 2p "$RESULTDIR/nodes.mac" | awk '{ print $1; }'`

cmd=`grep "${nodes[0]}" "$NODETABLE" | grep -v "#${nodes[0]}"  |  awk '{ print $7; }'`
if [ "x$cmd" = "xsender.click" ]; then
	sender_idx=0
else
	sender_idx=1
fi

# sum up received packets
mac=`cat $RESULTDIR/nodes.mac | \
	grep ${nodes[$sender_idx]} | \
	awk '{ print $3; }' | \
	sed s/:/-/g`





# Extrahiere Rate und prüfen, ob sie sich veränedert
# OKPacket: 1317835802.696444: 1492 |  1Mb +15/-95 | data nods FF-FF-FF-FF-FF-FF C4-3D-C7-90-CA-8D 00-00-00-00-00-00 seq: 315 [ ] 
result=`fromdump.sh $RESULTDIR/$DUMP_FILE | \
		grep $mac | \
		grep "[0-9]\+Mb" --only-matching | \
		sort -u | \
		wc -l`
		
if [ $result -eq 12 ]; then
echo $result "different rates. ok!"
else
echo "FAIL: Expecting 12 different rates."
exit 2
fi
exit 0
