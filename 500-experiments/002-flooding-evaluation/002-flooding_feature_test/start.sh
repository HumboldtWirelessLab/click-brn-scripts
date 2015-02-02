#!/bin/sh

#FLOODALGOS="simple probability mpr"
FLOODALGOS="simple"
#FLOODALGOS="mpr"

FLOODINGPASSIVACK="0 1"

FLOODINGUNICAST="0 1 2 3 4"
#FLOODINGUNICAST="0 1 2"
#FLOODINGUNICAST="0"

PROB_ARRAY=( 95 )
#PROB_ARRAY=( 60 70 75 80 85 90 95 100 )
#PROB_ARRAY=( 70 80 90 100 )
PROB_ARRAY_SIZE=${#PROB_ARRAY[@]}

if [ "x$START" = "x" ]; then
  START=1
fi

NUM=1

if [ "x$DATARATE" = "x" ]; then
  echo "Set DATARATE. Use DATARATE=x ./start.sh"
  exit 1
fi

if [ "x$NO_NODES" = "x" ]; then
  NO_NODES=20
fi

NODESFILE=nodes.sim

seq $NO_NODES | awk '{print "sk"$1 }' > $NODESFILE

if [ "x$LIMIT" = "x" ]; then
  LIMIT=`cat $NODESFILE | grep -v "#" | wc -w`
fi

for i in `cat $NODESFILE | grep -v "#"`; do

 if [ $NUM -lt $START ]; then
   let NUM=NUM+1
   continue
 fi

 for flunic in $FLOODINGUNICAST; do

     for al in $FLOODALGOS; do


       DONE_ALL_FOR_ALG=0

       while [ $DONE_ALL_FOR_ALG -eq 0 ]; do

       MEASUREMENTDIR="$DATARATE""_MBit_"$NUM"_plm_0_"$al

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

       #if [ $flunic -gt 0 ]; then
         echo "#define BCAST2UNIC" >> flooding_config.h
         echo "#define BCAST2UNIC_STRATEGY $flunic" >> flooding_config.h
       #fi

       echo "$i $al $PROBINDEX $NUM $LIMIT"

       if [ ! -e $MEASUREMENTDIR ]; then
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

         cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" | sed "s#NODES#nodes.sim#g" > flooding.mes

         cat flooding_tx.click.tmpl | grep -v "flooding_init" > flooding.click
         cat flooding_tx.click.tmpl | sed "s#NODEMACADDR#$MAC#g" > flooding_tx.click


        #mkdir $MEASUREMENTDIR
        PREPARE_ONLY=1 run_sim.sh ns flooding.des $MEASUREMENTDIR

        echo "SIM=1" > $MEASUREMENTDIR/params

        echo "ALGORITHM=$al" >> $MEASUREMENTDIR/params

        if [ "x$PROBINDEX" = "x" ]; then
          echo "FWDPROBALILITY=-1" >> $MEASUREMENTDIR/params
        else
          echo "FWDPROBALILITY=${PROB_ARRAY[$PROBINDEX]}" >> $MEASUREMENTDIR/params
        fi

        echo "UNICASTSTRATEGY=$flunic" >> $MEASUREMENTDIR/params

        echo "PLACEMENT=0" >> $MEASUREMENTDIR/params

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

 if [ $NUM -ge $LIMIT ]; then
   rm -f flooding.mes flooding.click flooding_tx.click flooding_config.h $NODEFILE

   sh ./run_para_sim.sh

   exit 0
 fi

 let NUM=NUM+1

done

rm -f flooding.mes flooding.click flooding_tx.click flooding_config.h $NODEFILE

sh ./run_para_sim.sh
