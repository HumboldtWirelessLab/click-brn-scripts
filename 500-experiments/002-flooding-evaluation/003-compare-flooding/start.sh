#!/bin/bash

#USE: SIM=1 DATARATE=1 LIMIT=1 GRID=1 ./start.sh
#USE: SIM=1 DATARATE=1 LIMIT=5 PLACEMENTFILE="placements_random.dat" PLACEMENT=1 ./start.sh
#
#for i in `ls -d 1_MBit*`; do echo $i; cat $i/evaluation/flooding_info/floodingstats.csv | awk -F, '{print $6" "$2}'; done

if [ "x$MAINCONFIG" != "x" ]; then
  . $MAINCONFIG
fi

if [ "x$CONFIG" = "x" ]; then
  . ./simsetrc_small
else
  . $CONFIG
fi

if [ "x$START" = "x" ]; then
  START=1
fi

NUM=1

if [ "x$DATARATE" = "x" ]; then
  echo "Set DATARATE. Use DATARATE=x ./start.sh"
  exit 1
fi

if [ "x$PLACEMENT" != "x" ]; then
  MAX_PLACEMENT=$PLACEMENT
  MIN_PLACEMENT=$PLACEMENT
else
  MIN_PLACEMENT=1
fi

if [ "x$SIM" = "x1" ]; then
  NODESFILE=nodes.sim

  if [ "x$GRID" = "x1" ]; then
    echo -n "" > $NODESFILE
    for i in `seq 1 36`; do
      echo "sk$i" >> $NODESFILE
    done
    MAX_PLACEMENT=1
  else
    cat $PLACEMENTFILE | awk '{print $2}' | sort -u | sort -n > $NODESFILE
    if [ "x$MAX_PLACEMENT" = "x" ]; then
      MAX_PLACEMENT=`cat $PLACEMENTFILE | awk '{print $1}' | sort -u | sort -n | tail -n 1`
    fi
  fi
else
  NODESFILE=nodes.measurement
  MAX_PLACEMENT=1
fi

if [ "x$LIMIT" = "x" ]; then
  LIMIT=`cat $NODESFILE | grep -v "#" | wc -w`
  let NO_NODES=NODES-1
fi

CURRENTRUNMODE=REBOOT

RUNMODE_RESET_COUNT=0

echo "Placementfile: $PLACEMENTFILE MAXPL: $MAX_PLACEMENT START: $START LIMIT: $LIMIT"

FLOWTIME=110
FLOWTIMESPACE=10
INTERVAL=1500
DURATION=15
DURATION_MS=15000

echo -n "" > flooding.ctl

for n in `cat $NODESFILE | grep -v "#" | head -n $LIMIT`; do
   if [ "x$SIM" = "x" ]; then
     MAC=`cat nodes.mac | grep $n | awk '{print $3}'`
   else
     mac_raw=`echo $n | sed "s#sk##g"`
     m1=`expr $mac_raw / 256`
     m2=`expr $mac_raw % 256`
     m1h=$(echo "obase=16; $m1" | bc)
     m2h=$(echo "obase=16; $m2" | bc)
     if [ $m1 -lt 16 ]; then
       m1h="0$m1h"
     fi
     if [ $m2 -lt 16 ]; then
       m2h="0$m2h"
     fi

     MAC="00-00-00-00-$m1h-$m2h"
   fi

   echo "$FLOWTIME $n DEV0 write sf add_flow $MAC FF-FF-FF-FF-FF-FF $INTERVAL 100 0 $DURATION_MS true" >> flooding.ctl

   let FLOWTIME=FLOWTIME+DURATION
   let FLOWTIME=FLOWTIME+FLOWTIMESPACE

done


#for n in `cat $NODESFILE | grep -v "#"`; do
#  echo "$FLOWTIME  $n DEV0 read flooding/fl stats" >> flooding.ctl
#  echo "$FLOWTIME  $n DEV0 read flooding/fl forward_table" >> flooding.ctl
#  echo "$FLOWTIME  $n DEV0 read flooding/unicfl stats" >> flooding.ctl
#  echo "$FLOWTIME  $n DEV0 read sf stats" >> flooding.ctl
#  read setrtscts.stats,
#  read rate_flooding.stats
#done

echo "Script( wait $FLOWTIME," > flooding_script.click

echo "  read flooding/fl.stats," >> flooding_script.click
echo "  read flooding/fl.forward_table," >> flooding_script.click
echo "  read flooding/unicfl.stats," >> flooding_script.click
echo "  read sf.stats," >> flooding_script.click
echo "  read setrtscts.stats," >> flooding_script.click
echo "  read rate_flooding.stats" >> flooding_script.click

echo ");" >> flooding_script.click


let FLOWTIME=FLOWTIME+1

for pl in `seq $MIN_PLACEMENT $MAX_PLACEMENT`; do

   if [ "x$SIM" = "x1" ]; then
     if [ "x$GRID" = "x" ]; then
       cat $PLACEMENTFILE | grep -e "^$pl " | sed -e "s#^$pl ##g" > placement.txt
       cat placement.txt | awk '{print $1}' > nodes.sim
     fi
   fi

   for flunic in $FLOODINGUNICAST; do

     if [ "x$flunic" = "x0" ]; then
       FLOODINGUNICAST_PRESELECTION_F="0"
       FLOODINGUNICAST_REJECT_EMPTYCS_F="false"
       FLOODINGUNICAST_PEER_METRIC_F="0"
       MAC_TRIES_F="1"
       NB_METRIC_F=$NB_METRIC
       PIGGYBACK_F="0"
       BCAST2UNIC_FORCERESPONSIBILITY_F="false"
       BCAST2UNIC_USEASSIGNINFO_F="false"
       FLOODINGABORTTX_F="0"
       FIXCS_PARAMS_F="false"
       FLOODING_E2E_RETRIES_F=$FLOODING_E2E_RETRIES
       RTS_CTS_F="0"
       BO_SCHEMES_F="0"
       RS_SCHEMES_F="0"
     else
       FLOODINGUNICAST_PRESELECTION_F=$FLOODINGUNICAST_PRESELECTION
       FLOODINGUNICAST_REJECT_EMPTYCS_F=$FLOODINGUNICAST_REJECT_EMPTYCS
       FLOODINGUNICAST_PEER_METRIC_F=$FLOODINGUNICAST_PEER_METRIC
       MAC_TRIES_F=$MAC_TRIES
       NB_METRIC_F=$NB_METRIC
       PIGGYBACK_F=$PIGGYBACK
       BCAST2UNIC_FORCERESPONSIBILITY_F=$BCAST2UNIC_FORCERESPONSIBILITY
       BCAST2UNIC_USEASSIGNINFO_F=$BCAST2UNIC_USEASSIGNINFO
       FLOODINGABORTTX_F=$FLOODINGABORTTX
       FIXCS_PARAMS_F=$FIXCS_PARAMS
       FLOODING_E2E_RETRIES_F="0"
       RTS_CTS_F=$RTS_CTS
       BO_SCHEMES_F=$BO_SCHEMES
       RS_SCHEMES_F=$RS_SCHEMES
     fi

   for flunic_pres in $FLOODINGUNICAST_PRESELECTION_F; do
   for flunic_reject in $FLOODINGUNICAST_REJECT_EMPTYCS_F; do
   for flunic_peer in $FLOODINGUNICAST_PEER_METRIC_F; do
   for flunic_fixcs in $FIXCS_PARAMS_F; do

    for fl_abort_tx in $FLOODINGABORTTX_F; do
    for fl_pa_ret in $FLOODINGPASSIVACK_RETRIES; do
    for fl_mac_ret in $MAC_TRIES_F; do
    for fl_nb_met in $NB_METRIC_F; do
    for fl_piggy in $PIGGYBACK_F; do
    for fl_forceresp in $BCAST2UNIC_FORCERESPONSIBILITY_F; do
    for fl_useassign in $BCAST2UNIC_USEASSIGNINFO_F; do
    for fl_maxdelay in $BCAST_RNDDELAYQUEUE_MAXDELAY; do

    for fl_e2e in $FLOODING_E2E_RETRIES_F; do

    for rtscts in $RTS_CTS_F; do

    if [ "x$rtscts" = "x0" ]; then
      RTSCTS_MIXED_F=$RTSCTS_MIXED
    else
      RTSCTS_MIXED_F="0"
    fi

    for rtscts_mixed in $RTSCTS_MIXED_F; do
    for bos in $BO_SCHEMES_F; do
    for rs in $RS_SCHEMES_F; do

     for al in $FLOODALGOS; do

       DONE_ALL_FOR_ALG=0

       while [ $DONE_ALL_FOR_ALG -eq 0 ]; do

       MEASUREMENTDIR="$DATARATE""_MBit_"$NUM"_plm_"$pl"_"$al"_"$flunic"_"$flunic_pres"_"$flunic_reject"_"$flunic_peer"_"$fl_pa_ret"_"$fl_mac_ret"_"$fl_nb_met"_"$fl_piggy"_"$fl_forceresp"_"$fl_useassign"_"$fl_maxdelay"_"$fl_abort_tx"_"$flunic_fixcs"_"$fl_e2e"_"$rtscts"_"$rtscts_mixed"_"$bos"_"$rs

       case "$al" in
         "simple")
                 echo "" > flooding_config.h
                 ;;
         "probability")
                  if [ "x$PROBINDEX" = "x" ]; then
                    PROBINDEX=0
                  fi
                  MEASUREMENTDIR="$MEASUREMENTDIR""_p_"${PROB_ARRAY[$PROBINDEX]}
                  echo "#define FLOODING_DEBUG 2" > flooding_config.h
                  echo "#define PROBABILITYFLOODING_FWDPROBALILITY ${PROB_ARRAY[$PROBINDEX]}" >> flooding_config.h
                  echo "#define PRO_FL" >> flooding_config.h
                  ;;
         "mpr")
                 echo "#define MPR_STATS" > flooding_config.h
                 echo "#define MPR_FL" >> flooding_config.h
                 ;;

         "mst")
                 echo "#define MST_FL" > flooding_config.h
                 echo "#define FLOODING_DEBUG 4" >> flooding_config.h
                 ;;

       esac

       MEASUREMENTDIR="$MEASUREMENTDIR""_unicast_"$flunic

       echo "#define BCAST2UNIC" >> flooding_config.h
       echo "#define BCAST2UNIC_STRATEGY $flunic" >> flooding_config.h
       echo "#define BCAST2UNIC_PRESELECTION_STRATEGY $flunic_pres" >> flooding_config.h
       echo "#define BCAST2UNIC_REJECTONEMPTYCS $flunic_reject" >> flooding_config.h
       echo "#define BCAST2UNIC_UCASTPEERMETRIC $flunic_peer" >> flooding_config.h
       echo "#define FLOODING_PASSIVE_ACK_RETRIES $fl_pa_ret" >> flooding_config.h
       echo "#define DEFAULT_DATATRIES $fl_mac_ret" >> flooding_config.h
       echo "#define FLOODING_MAXNBMETRIC $fl_nb_met" >> flooding_config.h
       echo "#define FLOODING_LASTNODES_PP $fl_piggy" >> flooding_config.h
       echo "#define BCAST2UNIC_FORCERESPONSIBILITY $fl_forceresp" >> flooding_config.h
       echo "#define BCAST2UNIC_USEASSIGNINFO $fl_useassign" >> flooding_config.h
       echo "#define BCAST_RNDDELAYQUEUE_MAXDELAY $fl_maxdelay" >> flooding_config.h
       echo "#define BCAST_ENABLE_ABORT_TX $fl_abort_tx" >> flooding_config.h
       echo "#define BCAST2UNIC_FIXCS $flunic_fixcs" >> flooding_config.h
       echo "#define BCAST_E2E_RETRIES $fl_e2e" >> flooding_config.h
       echo "#define RTSCTS_STRATEGY $rtscts" >> flooding_config.h
       echo "#define RTSCTS_MIXEDSTRATEGY $rtscts_mixed" >> flooding_config.h
       echo "#define TOS2QUEUEMAPPER_STRATEGY $bos" >> flooding_config.h
       echo "#define RS_STRATEGY $rs" >> flooding_config.h

       if [ "x$flunic" = "x0" ]; then
         echo "#define BCAST_FPA_ABORTONFINISH false" >> flooding_config.h
       fi

       echo "$NUM $al $PROBINDEX $NUM $LIMIT $flunic $flunic_pres $flunic_reject $flunic_peer $fl_pa_ret $fl_mac_ret $fl_nb_met $fl_piggy $fl_forceresp $fl_useassign $fl_maxdelay $fl_abort_tx $flunic_fixcs $fl_e2e $rtscts $rtscts_mixed $bos $rs"

       if [ ! -e $MEASUREMENTDIR ]; then

         if [ "x$SIM" = "x" ]; then
           cat flooding.mes.tmpl | sed "s#LOGDIR#/tmp#g" | sed "s#NODES#nodes.measurement#g" > flooding.mes
         else
           cat flooding.mes.tmpl | sed "s#NODES#nodes.sim#g" > flooding.mes
         fi

         if [ "x$GRID" = "x" ]; then
           cat flooding.des.tmpl | sed "s#FLOWTIME#$FLOWTIME#g" > flooding.des
         else
           cat flooding_grid.des.tmpl | sed "s#FLOWTIME#$FLOWTIME#g" > flooding.des
         fi

         echo "SEED=$NUM" >> flooding.des

         if [ "x$SIM" = "x" ]; then
           RUNMODE=$CURRENTRUNMODE run_measurement.sh flooding.des $MEASUREMENTDIR

           CURRENTRUNMODE=CLICK
           let RUNMODE_RESET_COUNT=RUNMODE_RESET_COUNT+1

           if [ $RUNMODE_RESET_COUNT -eq 10 ]; then
             CURRENTRUNMODE=REBOOT
             RUNMODE_RESET_COUNT=0
           fi

         else
           PREPARE_ONLY=1 run_sim.sh ns flooding.des $MEASUREMENTDIR
         fi

         if [ "x$SIM" = "x" ]; then
           echo "SIM=0" > $MEASUREMENTDIR/params
         else
           echo "SIM=1" > $MEASUREMENTDIR/params
        fi

        echo "ALGORITHM=$al" >> $MEASUREMENTDIR/params

        if [ "x$PROBINDEX" = "x" ]; then
          echo "FWDPROBALILITY=-1" >> $MEASUREMENTDIR/params
        else
          echo "FWDPROBALILITY=${PROB_ARRAY[$PROBINDEX]}" >> $MEASUREMENTDIR/params
        fi

        echo "UNICASTSTRATEGY=$flunic" >> $MEASUREMENTDIR/params
        echo "PLACEMENT=$pl" >> $MEASUREMENTDIR/params
        echo "UNICAST_PRESELECTION_STRATEGY=$flunic_pres" >> $MEASUREMENTDIR/params
        echo "UNICAST_REJECTONEMPTYCS=$flunic_reject" >> $MEASUREMENTDIR/params
        echo "UNICAST_UCASTPEERMETRIC=$flunic_peer" >> $MEASUREMENTDIR/params
        echo "FLOODING_PASSIVE_ACK_RETRIES=$fl_pa_ret" >> $MEASUREMENTDIR/params
        echo "MACRETRIES=$fl_mac_ret" >> $MEASUREMENTDIR/params
        echo "FLOODING_MAXNBMETRIC=$fl_nb_met" >> $MEASUREMENTDIR/params
        echo "FLOODING_LASTNODES_PP=$fl_piggy" >> $MEASUREMENTDIR/params
        echo "SEED=$NUM" >> $MEASUREMENTDIR/params
        echo "BCAST2UNIC_FORCERESPONSIBILITY=$fl_forceresp" >> $MEASUREMENTDIR/params
        echo "BCAST2UNIC_USEASSIGNINFO=$fl_useassign" >> $MEASUREMENTDIR/params
        echo "BCAST_RNDDELAYQUEUE_MAXDELAY=$fl_maxdelay" >> $MEASUREMENTDIR/params
        echo "BCAST_ENABLE_ABORT_TX=$fl_abort_tx" >> $MEASUREMENTDIR/params
        echo "BCAST2UNIC_FIXCS=$flunic_fixcs" >> $MEASUREMENTDIR/params
        echo "BCAST_E2E_RETRIES=$fl_e2e" >> $MEASUREMENTDIR/params
        echo "RTSCTS_STRATEGY=$rtscts" >> $MEASUREMENTDIR/params
        echo "RTSCTS_MIXEDSTRATEGY=$rtscts_mixed" >> $MEASUREMENTDIR/params
        echo "BO_STRATEGY=$bos" >> $MEASUREMENTDIR/params
        echo "RS_STRATEGY=$rs" >> $MEASUREMENTDIR/params

       fi

       case "$al" in
         "simple")
                 DONE_ALL_FOR_ALG=1
                 ;;
         "probability")
                  let PROBINDEX=PROBINDEX+1;

                  if [ $PROBINDEX -ge $PROB_ARRAY_SIZE ]; then
                    DONE_ALL_FOR_ALG=1
                    PROBINDEX=""
                  fi
                  ;;
         "mpr")
                 DONE_ALL_FOR_ALG=1
                 ;;
         "mst")
                 DONE_ALL_FOR_ALG=1
                 ;;
       esac


      done

    done
    if [ -f ./finish ]; then
      exit
    fi
  done
  done
  done
  done
 done
 done
 done
 done
 done
 done
 done
 done
 done
 done
 done
 done
 done
 done
 let NUM=NUM+1
done

rm -f flooding_config.h placement.txt nodes.sim flooding.des flooding.mes flooding.ctl flooding_script.click

if [ "x$SIM" = "x1" ]; then
  run_para_sim.sh
fi
