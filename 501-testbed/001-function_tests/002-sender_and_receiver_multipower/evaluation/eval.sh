#!/bin/bash
# Author: kuehne@informatik.hu-berlin.de
# Function: Stream-Test; checks function set_power() 


. $CONFIGFILE

# Init
threshold=50			# (in percent) threshold for positive result of stream test
duration=$TIME			# duration of experiment
period_length=10		# length of period
tmp=0
exit_code=0






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



timeOffset=`fromdump.sh $RESULTDIR/$DUMP_FILE | \
		head -n 1 | \
		grep "[0-9]\{10\}\.[0-9]\{2\}" --only-matching`		# get number through float point, otherwise length not known

# convert float to int
timeOffset=${timeOffset/\.*}

if [ "$timeOffset" = "" ]; then
	echo "timeOffset is undefined. exit."
	exit
fi

for ((i=$timeOffset;i<($timeOffset+$duration);i+=$period_length))
do
	# todo
	# 1. powerrate extrahieren
	# 2. durschnitt in jeder phase bilden
	# 3. ausgeben und nach kriterium bewerten: jede phase muss sich um mindestens 4 db unterscheiden
	# Bsp: Hier muss die +15 herausextrahiert werden...
	# OKPacket: 1317835802.696444: 1492 |  1Mb +15/-95 | data nods FF-FF-FF-FF-FF-FF C4-3D-C7-90-CA-8D 00-00-00-00-00-00 seq: 315 [ ] 

	result=`fromdump.sh $RESULTDIR/$DUMP_FILE | \
		grep $mac | \
		awk -v i=$i -v period_length=$period_length -v t=0 -v sum_rate=0 '
		{
			# stupid hack: cut ":" as last position from time-field
			timestamp=substr($2,0,(length($2)-1));

			# check if in valid time range
			if (i<timestamp && timestamp<(i+period_length)) 
			{
				start=match($6, "+[0-9]");		# 
				end=match($6,"/");			#  
				rate=substr($6, start+1, end-start-1); 	# 
				sum_rate+=rate; 			# sum all rates to calculate later average value
				t++;
			}
		}
		END {
			average_rate=sum_rate/t;
			print average_rate;
		}
		'`
	
	# Make diffs between values and evaluate them	
	for entry in $result
	do
		INT_entry=${entry/.*}
		diff=$[$tmp - $INT_entry]
		
		# eval if 4 <= value <= 6
		if [ 4 -le $diff ] && [ $diff -le 6 ]; then 
			eval="ok!"
		else
			eval="FAIL: The power rates have either not changed or are unexpectedly too high. (for all x be 4<=x<=5)"
			exit_code=2
			
		fi
		if [ ! $tmp -eq 0 ]; then echo "Diff:" $diff "..." $eval; fi
		
		tmp=$INT_entry
	done
done

exit $exit_code






