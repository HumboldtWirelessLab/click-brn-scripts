#!/bin/sh

RESULTDIR=$1

ALGSEDARG="-e s#simple#0#g -e s#probability#1#g -e s#mpr#2#g -e s#mst#3#g"

echo -n "" > result_flooding.dat

echo -n "" > result_flooding_info.dat
echo -n "" > result_flooding_info_index.dat

INFOINDEX=0

for d in `(cd $RESULTDIR; ls -l | grep "^d" | grep -v "evaluation" | awk '{print $NF}')`; do
  if [ -e $RESULTDIR/$d/params ]; then
    . $RESULTDIR/$d/params

    SIMID=`echo $d | sed -e "s#_# #g" | awk '{print $3}'`

    ALGORITHMID=`echo $ALGORITHM | sed $ALGSEDARG`

    EXTRAINFO=$FWDPROBALILITY

    INFO="$SIMID $SIM $UNICASTSTRATEGY $PLACEMENT $UNICAST_PRESELECTION_STRATEGY $UNICAST_REJECTONEMPTYCS $UNICAST_UCASTPEERMETRIC $FLOODING_PASSIVE_ACK_RETRIES $ALGORITHMID"

    INFO="$INFO $FWDPROBALILITY $UNICASTSTRATEGY"

    INFO="$INFO $MACRETRIES $FLOODING_MAXNBMETRIC $FLOODING_LASTNODES_PP $BCAST2UNIC_FORCERESPONSIBILITY $BCAST2UNIC_USEASSIGNINFO"
    INFO="$INFO $BCAST_RNDDELAYQUEUE_MAXDELAY $SEED $BCAST2UNIC_TXABORT $BCAST2UNIC_FIXCS $BCAST_E2E_RETRIES $RTSCTS_STRATEGY"
    INFO="$INFO $RTSCTS_MIXEDSTRATEGY $BO_STRATEGY $RS_STRATEGY $FLOODING_TX_SCHEDULING"

    INFO=`echo "$INFO" | sed -e "s#true#1#g" | sed -e "s#false#0#g"`

    echo "$INFOINDEX $INFO" >> result_flooding_info_index.dat

    #            COLLISIONEN RTS CTS DATA BCAST UNIC ACK
    EXTRA_DATA=`awk -F, '{print $14" "$2" "$3" "$4" "$5" "$6" "$7}' $RESULTDIR/$d/evaluation/channelstats/simstats_summary.csv`

    if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingstats.csv ]; then
      cat $RESULTDIR/$d/evaluation/flooding_info/floodingstats.csv | sed "s#,# #g" | awk -v I="$INFOINDEX" -v EXDAT="$EXTRA_DATA" '{print I" "$3" "$10" "$2" "$1" "$7" "$9" "$6" "$5" "EXDAT }' >> result_flooding.dat
    fi

    # node node node psize 0 0 0 0 0 pcount value fwd sent 0 0 0 0 0 fwd_done fwd_succ time
    if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat ]; then
      cat $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat | awk -v I=$INFOINDEX -v EXDAT="$EXTRA_DATA" '{print I" "$0 }' >> result_flooding_info.dat
    else
      if [ -f $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat.bz2 ]; then
        bzcat $RESULTDIR/$d/evaluation/flooding_info/floodingsmallstats.mat.bz2 | awk -v I=$INFOINDEX -v EXDAT="$EXTRA_DATA" '{print I" "$0 }' >> result_flooding_info.dat
      fi
    fi

    if [ -f $RESULTDIR/$d/evaluation/flow_info/flowtime.mat ]; then
      cat $RESULTDIR/$d/evaluation/flow_info/flowtime.mat | awk -v I=$INFOINDEX -v EXDAT="$EXTRA_DATA" '{print I" "$0 }' >> result_flowtime.dat
    else
      if [ -f $RESULTDIR/$d/evaluation/flow_info/flowtime.mat.bz2 ]; then
        bzcat $RESULTDIR/$d/evaluation/flow_info/flowtime.mat.bz2 | awk -v I=$INFOINDEX -v EXDAT="$EXTRA_DATA" '{print I" "$0 }' >> result_flowtime.dat
      fi
    fi

  fi

  let INFOINDEX=INFOINDEX+1

done

#echo "SIMID SIM UNICASTSTRATEGY PLACEMENT UNICAST_PRESELECTION_STRATEGY UNICAST_REJECTONEMPTYCS UNICAST_UCASTPEERMETRIC FLOODING_PASSIVE_ACK_RETRIES ALG FWDPROBALILITY UNICASTSTRATEGY PDR NOSRC RECVNEW NONODE FWDS FWDNEW SENT RECV COLLISIONEN MACRETRIES FLOODING_MAXNBMETRIC FLOODING_LASTNODES_PP BCAST2UNIC_FORCERESPONSIBILITY BCAST2UNIC_USEASSIGNINFO BCAST_RNDDELAYQUEUE_MAXDELAY SEED BCAST2UNIC_TXABORT BCAST2UNIC_FIXCS BCAST_E2E_RETRIES RTSCTS_STRATEGY RTSCTS_MIXEDSTRATEGY BO_STRATEGY RS_STRATEGY RTS CTS BCAST UNIC ACK" > result_flooding_xls.dat
#cat result_flooding.dat >> result_flooding_xls.dat

exit 0

