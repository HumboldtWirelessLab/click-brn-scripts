#!/bin/sh

RESULTDIR=$1

ALGSEDARG="-e s#simple#0#g -e s#probability#1#g -e s#mpr#2#g -e s#mst#3#g"

echo -n "" > result_flooding.dat
echo -n "" > result_flooding_info.dat

for d in `(cd $RESULTDIR; ls -l | grep "^d" | grep -v "evaluation" | awk '{print $NF}')`; do
  if [ -e $RESULTDIR/$d/params ]; then
    . $RESULTDIR/$d/params

    SIMID=`echo $d | sed -e "s#_# #g" | awk '{print $3}'`

    EXTRAINFO=$FWDPROBALILITY

    ALGORITHMID=`echo $ALGORITHM | sed $ALGSEDARG`
    UNICAST_REJECTONEMPTYCS=`echo $UNICAST_REJECTONEMPTYCS | sed -e "s#true#1#g" | sed -e "s#false#0#g"`
    BCAST2UNIC_FORCERESPONSIBILITY=`echo $BCAST2UNIC_FORCERESPONSIBILITY | sed -e "s#true#1#g" | sed -e "s#false#0#g"`
    BCAST2UNIC_USEASSIGNINFO=`echo $BCAST2UNIC_USEASSIGNINFO | sed -e "s#true#1#g" | sed -e "s#false#0#g"`
    BCAST2UNIC_TXABORT=`echo $BCAST_ENABLE_ABORT_TX | sed -e "s#true#1#g" | sed -e "s#false#0#g"`
    BCAST2UNIC_FIXCS=`echo $BCAST2UNIC_FIXCS | sed -e "s#true#1#g" | sed -e "s#false#0#g"`

    INFO="$SIM $UNICASTSTRATEGY $PLACEMENT $UNICAST_PRESELECTION_STRATEGY $UNICAST_REJECTONEMPTYCS $UNICAST_UCASTPEERMETRIC $FLOODING_PASSIVE_ACK_RETRIES"

    COLLISIONEN=`awk -F, '{print $14}' $RESULTDIR/$d/evaluation/channelstats/simstats_summary.csv`
    RTS=`awk -F, '{print $2}' $RESULTDIR/$d/evaluation/channelstats/simstats_summary.csv`
    CTS=`awk -F, '{print $3}' $RESULTDIR/$d/evaluation/channelstats/simstats_summary.csv`
    DATA=`awk -F, '{print $4}' $RESULTDIR/$d/evaluation/channelstats/simstats_summary.csv`
    BCAST=`awk -F, '{print $5}' $RESULTDIR/$d/evaluation/channelstats/simstats_summary.csv`
    UNIC=`awk -F, '{print $6}' $RESULTDIR/$d/evaluation/channelstats/simstats_summary.csv`
    ACK=`awk -F, '{print $7}' $RESULTDIR/$d/evaluation/channelstats/simstats_summary.csv`

    EXTRA_DATA="$COLLISIONEN $MACRETRIES $FLOODING_MAXNBMETRIC $FLOODING_LASTNODES_PP $BCAST2UNIC_FORCERESPONSIBILITY $BCAST2UNIC_USEASSIGNINFO $BCAST_RNDDELAYQUEUE_MAXDELAY $SEED $BCAST2UNIC_TXABORT $BCAST2UNIC_FIXCS $BCAST_E2E_RETRIES $RTS $CTS $BCAST $UNIC $ACK"

    if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingstats.csv ]; then
      cat $RESULTDIR/$d/evaluation/flooding_info/floodingstats.csv | sed "s#,# #g" | awk -v ALG=$ALGORITHMID -v N=$SIMID -v I="$INFO" -v E=$EXTRAINFO -v L=$UNICASTSTRATEGY -v EXDAT="$EXTRA_DATA" '{print N" "I" "ALG" "E" "L" "$3" "$10" "$2" "$1" "$7" "$9" "$6" "$5" "EXDAT }' >> result_flooding.dat
    fi

    if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat ]; then
      cat $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat | awk -v ALG=$ALGORITHMID -v N=$SIMID -v I="$INFO" -v E=$EXTRAINFO -v L=$UNICASTSTRATEGY -v EXDAT="$EXTRA_DATA" '{print N" "$0" "I" "ALG" "E" "L" "EXDAT }' >> result_flooding_info.dat
    else
      if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat.bz2 ]; then
        bzcat $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat.bz2 | awk -v ALG=$ALGORITHMID -v N=$SIMID -v I="$INFO" -v E=$EXTRAINFO -v L=$UNICASTSTRATEGY -v EXDAT="$EXTRA_DATA" '{print N" "$0" "I" "ALG" "E" "L" "EXDAT }' >> result_flooding_info.dat
      fi
   fi
  fi

done

exit 0

