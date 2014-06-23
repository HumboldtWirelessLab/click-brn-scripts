#!/bin/bash

# Settings
if [ $# -le 0 ]
then
	echo "$0 cvs_to_transponate"
	exit -1
fi


# Convert
awk -F "," '
{ 
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {    
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str","a[i,j];
        }
        print str
    }
}' ${1}