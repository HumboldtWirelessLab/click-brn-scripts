#!/bin/sh

#echo $0 `pwd`

if [[ $# -gt 0 ]]; then
	echo "Processing $1";
	dumpDirectories=$1;
else
	echo "Processing all subdirectories:"
	dumpDirectories=`( ls -l | grep "^d" | awk '{print $8 }' )`;
fi

currDir=`pwd`;

# for every directory
for dumpdirectory in $dumpDirectories;do
	
	echo "Entering: "$dumpdirectory
	
	# go into the directory
	cd $dumpdirectory

	# for every dumpfile within the directory
	for dumpfile in `(ls *.dump )`; do

		# get the prefix
		prefix=`echo $dumpfile | sed "s#\.# #g" | awk '{print $1"."$2}'`;
	
		echo "	creating dumpfile for "$prefix
		ATH=yes;
		WIFI=805;
		export GPS ATH WIFI;
	
		echo "	ATH=$ATH WIFI=$WIFI fromdump.sh $dumpfile > $prefix.dat"
		# create the printout and dump it into a file
		fromdump.sh $dumpfile | awk '{print "LAT: 0.0 LONG: 0.0 ALT: 0.0 SPEED: 0.0 "$0 }' > $prefix.dat
		
		# create the the files
		#cat $prefix.dat | awk -vPREFIX=$prefix -f $currDir"/"genMatlabFile.awk
		
		# add to svn
		#svn add $prefix".ssid.idx" $prefix".stringmap.idx" $prefix".data.dat" $prefix".ignoredlines.log";

	done;	
	
	echo "Leaving: "$dumpdirectory
	# back to where we started
	cd $currDir

done;







#PATH=$PATH:/home/jojo/Arbeit/T-Project/SVN/t-project/helper/evaluation/bin

#cat $1 | awk -vPREFIX=$2 -f /home/jojo/Arbeit/T-Project/SVN/t-project/helper/evaluation/scenarios/matlab/genMatlabFile.awk

#  GPS=yes; ATH=yes; WIFI=805;export GPS ATH WIFI; fromdump.sh 
