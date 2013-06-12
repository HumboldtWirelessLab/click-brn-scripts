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
    UNICAST_REJECTONEMPTYCS=`echo $UNICAST_REJECTONEMPTYCS | sed -e "s#true#1#g" | sed -e "s#false#0#g"`

    INFO="$SIM $UNICASTSTRATEGY $PLACEMENT $UNICAST_PRESELECTION_STRATEGY $UNICAST_REJECTONEMPTYCS $UNICAST_UCASTPEERMETRIC $FLOODING_PASSIVE_ACK_RETRIES"

    cat $RESULTDIR/$d/evaluation/flooding_info/floodingstats.csv | sed "s#,# #g" | awk -v ALG=$ALGORITHMID -v N=$SIMID -v I="$INFO" -v E=$EXTRAINFO -v L=$UNICASTSTRATEGY '{print N" "I" "ALG" "E" "L" "$3" "$4" "$6" "$7" "$1}' >> result_flooding.dat
  fi

done

exit 0
