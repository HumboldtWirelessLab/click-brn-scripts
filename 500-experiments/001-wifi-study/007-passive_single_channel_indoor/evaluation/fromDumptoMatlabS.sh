#!/bin/sh

#echo $0 `pwd`

if [[ $# -gt 0 ]]; then
	echo "Processing $1 $2";
	dumpdirectory=$1;
	dumpfile=$2;
else
	echo "Missing arguments:"
	exit
fi

currDir=`pwd`;

echo "Entering: "$dumpdirectory
	
# go into the directory
cd $dumpdirectory

echo "Processing: "$dumpfile
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
cat $prefix.dat | awk -vPREFIX=$prefix -f $currDir"/"genMatlabFile.awk
		
echo "Leaving: "$dumpdirectory
# back to where we started
cd $currDir

