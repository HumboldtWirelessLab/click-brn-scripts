#!/bin/sh

. $CONFIGFILE

cd $RESULTDIR 
echo "\"distance\" \"received_packages\" \"real_sent\"" > $RESULTDIR/rx_result.dat
REAL_SENT=$(grep -e "<txflow.*src=\"00-00-00-00-00-01\".*dst=\"FF-FF-FF-FF-FF-FF\"" measurement.log | awk -F'"' '{print $8}')
NUM=$(ls sk*.eth0.raw.dump | wc -l)
for i in `seq 2 $NUM` 
do 
	let h=\(i-1\)*5; 
	fromdump.sh sk$i.eth0.raw.dump | wc -l | awk -v d=$h -v r=$REAL_SENT '{print d" "$0" "r}' >> $RESULTDIR/rx_result.dat
done

../evaluation/plot.R

cd - 

exit 0
