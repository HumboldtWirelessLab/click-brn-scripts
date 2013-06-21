#!/bin/bash

if [ "x$PLACEMENTFILE" = "x" ]; then
  PLACEMENTFILE=placements_npart.dat
fi

#FLOODALGOS="simple probability mpr"
FLOODALGOS="simple"
#FLOODALGOS="mpr"

PROB_ARRAY=( 95 85 )
#PROB_ARRAY=( 60 70 75 80 85 90 95 100 )
#PROB_ARRAY=( 70 80 90 100 )
PROB_ARRAY_SIZE=${#PROB_ARRAY[@]}


FLOODINGPASSIVACK_RETRIES="0 1 2 3 4 5"

FLOODINGUNICAST="0 4"

#FLOODINGUNICAST_PRESELECTION="0 1 2"
FLOODINGUNICAST_PRESELECTION="0 2"

#FLOODINGUNICAST_REJECT_EMPTYCS="true false"
FLOODINGUNICAST_REJECT_EMPTYCS="true"

FLOODINGUNICAST_PEER_METRIC="0 4"
#FLOODINGUNICAST_PEER_METRIC="0"


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

for i in `cat $NODESFILE | grep -v "#"`; do

 if [ $NUM -lt $START ]; then
   let NUM=NUM+1
#   echo "$NUM"
   continue
 fi

 if [ "x$i" = "xpc113" ]; then
   continue
 fi

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
     else
       FLOODINGUNICAST_PRESELECTION_F=$FLOODINGUNICAST_PRESELECTION
       FLOODINGUNICAST_REJECT_EMPTYCS_F=$FLOODINGUNICAST_REJECT_EMPTYCS
       FLOODINGUNICAST_PEER_METRIC_F=$FLOODINGUNICAST_PEER_METRIC
     fi

   for flunic_pres in $FLOODINGUNICAST_PRESELECTION_F; do
   for flunic_reject in $FLOODINGUNICAST_REJECT_EMPTYCS_F; do
   for flunic_peer in $FLOODINGUNICAST_PEER_METRIC_F; do

    for fl_pa_ret in $FLOODINGPASSIVACK_RETRIES; do

#FLOODINGPASSIVACK="0 1"
#FLOODINGPASSIVACK_RETRIES="0 1 2"

#FLOODINGUNICAST="0 4"
#FLOODINGUNICAST_PRESELECTION="0 1 2"
#FLOODINGUNICAST_REJECT_EMPTYCS="true false"
#FLOODINGUNICAST_PEER_METRIC="0 1 2 3 4 5"

     for al in $FLOODALGOS; do

       DONE_ALL_FOR_ALG=0

       while [ $DONE_ALL_FOR_ALG -eq 0 ]; do

       MEASUREMENTDIR="$DATARATE""_MBit_"$NUM"_plm_"$pl"_"$al"_"$flunic"_"$flunic_pres"_"$flunic_reject"_"$flunic_peer"_"$fl_pa_ret

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

       esac

       MEASUREMENTDIR="$MEASUREMENTDIR""_unicast_"$flunic

       echo "#define BCAST2UNIC" >> flooding_config.h
       echo "#define BCAST2UNIC_STRATEGY $flunic" >> flooding_config.h
       echo "#define BCAST2UNIC_PRESELECTION_STRATEGY $flunic_pres" >> flooding_config.h
       echo "#define BCAST2UNIC_REJECTONEMPTYCS $flunic_reject" >> flooding_config.h
       echo "#define BCAST2UNIC_UCASTPEERMETRIC $flunic_peer" >> flooding_config.h
       echo "#define FLOODING_PASSIVE_ACK_RETRIES $fl_pa_ret" >> flooding_config.h

       echo "$i $al $PROBINDEX $NUM $LIMIT $flunic $flunic_pres $flunic_reject $flunic_peer $fl_pa_ret"

       if [ ! -e $MEASUREMENTDIR ]; then
         if [ "x$SIM" = "x" ]; then
           MAC=`cat nodes.mac | grep $i | awk '{print $3}'`
         else
           mac_raw=`echo $i | sed "s#sk##g"`
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

         if [ "x$SIM" = "x" ]; then
           cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" | sed "s#LOGDIR#/tmp#g" | sed "s#NODES#nodes.measurement#g" > flooding.mes
         else
           cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" | sed "s#NODES#nodes.sim#g" > flooding.mes
         fi

         cat flooding_tx.click.tmpl | grep -v "flooding_init" > flooding.click
         cat flooding_tx.click.tmpl | sed "s#NODEMACADDR#$MAC#g" > flooding_tx.click

         cp flooding.des.tmpl flooding.des
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
           #mkdir $MEASUREMENTDIR
           if [ "x$GRID" = "x" ]; then
             PREPARE_ONLY=1 run_sim.sh ns flooding.des $MEASUREMENTDIR
           else
             PREPARE_ONLY=1 run_sim.sh ns flooding_grid.des $MEASUREMENTDIR
           fi
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

 if [ $NUM -ge $LIMIT ]; then
   rm -f flooding.mes flooding.click flooding_tx.click flooding_config.h placement.txt nodes.sim

   if [ "x$SIM" = "x1" ]; then
     /bin/bash ./run_para_sim.sh
   fi

   exit 0
 fi

 let NUM=NUM+1
# echo "$NUM"
done

rm -f flooding.mes flooding.click flooding_tx.click flooding_config.h placement.txt nodes.sim flooding.des

if [ "x$SIM" = "x1" ]; then
  /bin/bash ./run_para_sim.sh
fi