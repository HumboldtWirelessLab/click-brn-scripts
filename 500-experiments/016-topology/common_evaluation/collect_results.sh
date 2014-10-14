#!/bin/bash

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
  "/")
      DIR=$dir
      ;;
  ".")
      DIR=$pwd/$dir
      ;;
    *)
      echo "Error while getting directory"
      exit -1
      ;;
esac

first=true
for d in $(ls -d [0-9]*)
do
  if [ ! -f ${d}/result.csv ]
  then
    echo "Warning: No result file at $d" >&2
    continue
  fi

  # header
  if [ "${first}" == true  ]
  then
    $DIR/transponate_csv.sh ${d}/result.csv | awk -F ',' '{ OFS=","; $1=""; $0=substr($0,2); if(NR == 1) print "sample_nr",$0}'
    first=false
  fi

  # content
  $DIR/transponate_csv.sh ${d}/result.csv | awk -F ',' '{ OFS=","; $1=""; $0=substr($0,2); if(NR != 1) print sample_nr,$0}' sample_nr=${d}
done
