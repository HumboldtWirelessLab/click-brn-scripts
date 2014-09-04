#!/bin/bash

i=1
first=true
while [ -e "./$i" ]
do 
	# header
	if [ "${first}" == true  ]
	then
		../../common_evaluation/transponate_csv.sh ${i}/result.csv | awk -F ',' '{ OFS=","; $1=""; $0=substr($0,2); if(NR == 1) print "sample_nr",$0}'
		first=false
	fi

	# content
	../../common_evaluation/transponate_csv.sh ${i}/result.csv | awk -F ',' '{ OFS=","; $1=""; $0=substr($0,2); if(NR != 1) print sample_nr,$0}' sample_nr=${i}


	i=$((i+1));
done; i=$((i-1))