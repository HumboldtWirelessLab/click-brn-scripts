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

    COLLISIONEN=`cat $RESULTDIR/$d/evaluation/collisionen`

    if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingstats.csv ]; then
      cat $RESULTDIR/$d/evaluation/flooding_info/floodingstats.csv | sed "s#,# #g" | awk -v ALG=$ALGORITHMID -v N=$SIMID -v I="$INFO" -v E=$EXTRAINFO -v L=$UNICASTSTRATEGY -v C=$COLLISIONEN -v MR=$MACRETRIES -v MET=$FLOODING_MAXNBMETRIC -v PP=$FLOODING_LASTNODES_PP -v FR=$BCAST2UNIC_FORCERESPONSIBILITY -v UA=$BCAST2UNIC_USEASSIGNINFO -v QD=$BCAST_RNDDELAYQUEUE_MAXDELAY -v S=$SEED -v TXA=$BCAST2UNIC_TXABORT -v FCS=$BCAST2UNIC_FIXCS -v EER=$BCAST_E2E_RETRIES '{print N" "I" "ALG" "E" "L" "$3" "$10" "$2" "$1" "$7" "$9" "$6" "$5" "C" "MR" "MET" "PP" "FR" "UA" "QD" "S" "TXA" "FCS" "ERR }' >> result_flooding.dat
    fi

    if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat ]; then
      cat $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat | awk -v ALG=$ALGORITHMID -v N=$SIMID -v I="$INFO" -v E=$EXTRAINFO -v L=$UNICASTSTRATEGY -v C=$COLLISIONEN -v MR=$MACRETRIES -v MET=$FLOODING_MAXNBMETRIC -v PP=$FLOODING_LASTNODES_PP -v FR=$BCAST2UNIC_FORCERESPONSIBILITY -v UA=$BCAST2UNIC_USEASSIGNINFO -v QD=$BCAST_RNDDELAYQUEUE_MAXDELAY -v S=$SEED -v TXA=$BCAST2UNIC_TXABORT -v FCS=$BCAST2UNIC_FIXCS -v EER=$BCAST_E2E_RETRIES '{print N" "$0" "I" "ALG" "E" "L" "C" "MR" "MET" "PP" "FR" "UA" "QD" "S" "TXA" "FCS" "ERR }' >> result_flooding_info.dat
    else
      if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat.bz2 ]; then
        bzcat $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat.bz2 | awk -v ALG=$ALGORITHMID -v N=$SIMID -v I="$INFO" -v E=$EXTRAINFO -v L=$UNICASTSTRATEGY -v C=$COLLISIONEN -v MR=$MACRETRIES -v MET=$FLOODING_MAXNBMETRIC -v PP=$FLOODING_LASTNODES_PP -v FR=$BCAST2UNIC_FORCERESPONSIBILITY -v UA=$BCAST2UNIC_USEASSIGNINFO -v QD=$BCAST_RNDDELAYQUEUE_MAXDELAY -v S=$SEED -v TXA=$BCAST2UNIC_TXABORT -v FCS=$BCAST2UNIC_FIXCS -v EER=$BCAST_E2E_RETRIES '{print N" "$0" "I" "ALG" "E" "L" "C" "MR" "MET" "PP" "FR" "UA" "QD" "S" "TXA" "FCS" "ERR }' >> result_flooding_info.dat
      fi
   fi
  fi

done

exit 0

