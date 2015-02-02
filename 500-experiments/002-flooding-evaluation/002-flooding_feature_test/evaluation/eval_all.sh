#!/bin/sh

RESULTDIR=$1

ALGSEDARG="-e s#simple#0#g -e s#probability#1#g -e s#mpr#2#g"

echo -n "" > result_flooding.dat

for d in `(cd $RESULTDIR; ls -l | grep "^d" | grep -v "evaluation" | awk '{print $NF}')`; do
  if [ -e $RESULTDIR/$d/params ]; then
    . $RESULTDIR/$d/params

    SIMID=`echo $d | sed -e "s#_# #g" | awk '{print $3}'`

    EXTRAINFO=$FWDPROBALILITY

    ALGORITHMID=`echo $ALGORITHM | sed $ALGSEDARG`

    cat $RESULTDIR/$d/evaluation/flooding_info/floodingstats.csv | sed "s#,# #g" | awk -v ALG=$ALGORITHMID -v N=$SIMID -v E=$EXTRAINFO -v L=$UNICASTSTRATEGY '{print N" "ALG" "E" "L" "$3" "$4" "$6" "$7" "$1}' >> result_flooding.dat
  fi

done

exit 0
