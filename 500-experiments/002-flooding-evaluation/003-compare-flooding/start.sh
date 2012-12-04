#!/bin/sh

FLOODALGOS="simple probability mpr"
#FLOODALGOS="mpr"

FLOODINGPASSIVACK="0 1"

FLOODINGUNICAST="0 1 2"

#PROB_ARRAY=( 70 )
#PROB_ARRAY=( 60 70 75 80 85 90 95 100 )
PROB_ARRAY=( 70 80 90 100 )
PROB_ARRAY_SIZE=${#PROB_ARRAY[@]}

if [ "x$LIMIT" = "x" ]; then
  LIMIT=`cat nodes | grep -v "#" | wc -l`
fi

NUM=1

if [ "x$DATARATE" = "x" ]; then
  echo "Set DATARATE. Use DATARATE=x ./start.sh"
  exit 1
fi


CURRENTRUNMODE=REBOOT

RUNMODE_RESET_COUNT=0

for i in `cat nodes | grep -v "#"`; do

 for flunic in $FLOODINGUNICAST; do

     for al in $FLOODALGOS; do

       DONE_ALL_FOR_ALG=0

       while [ $DONE_ALL_FOR_ALG -eq 0 ]; do

       MEASUREMENTDIR="$DATARATE""_MBit_"$NUM"_"$al

       case "$al" in
         "simple")
                 echo "" > flooding_config.h
                 ;;
         "probability")
                  if [ "x$PROBINDEX" = "x" ]; then
                    PROBINDEX=0
                  fi
                  MEASUREMENTDIR="$MEASUREMENTDIR""_p_"${PROB_ARRAY[$PROBINDEX]}
                  echo "#define FLOODING_DEBUG 4" > flooding_config.h
                  echo "#define PROBABILITYFLOODING_FWDPROBALILITY ${PROB_ARRAY[$PROBINDEX]}" >> flooding_config.h
                  echo "#define PRO_FL" >> flooding_config.h
                  ;;
         "mpr")
                 echo "#define MPR_STATS" > flooding_config.h
                 echo "#define MPR_FL" >> flooding_config.h
                 ;;

       esac

       MEASUREMENTDIR="$MEASUREMENTDIR""_unicast_"$flunic

       if [ $flunic -gt 0 ]; then
         echo "#define BCAST2UNIC" >> flooding_config.h
         echo "#define BCAST2UNIC_STRATEGY $flunic" >> flooding_config.h
       fi

       echo "$i $al $PROBINDEX"

       if [ ! -e $MEASUREMENTDIR ]; then
         if [ "x$SIM" = "x" ]; then
           MAC=`cat nodes.mac | grep $i | awk '{print $3}'`
         else
           MAC=`cat nodes.mac.sim | grep $i | awk '{print $3}'`
         fi

         if [ "x$SIM" = "x" ]; then
           cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" | sed "s#LOGDIR#/tmp#g" > flooding.mes
         else
           cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" > flooding.mes
         fi

         cat flooding_tx.click.tmpl | grep -v "flooding_init" > flooding.click
         cat flooding_tx.click.tmpl | sed "s#NODEMACADDR#$MAC#g" > flooding_tx.click


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
           run_sim.sh ns flooding.des $MEASUREMENTDIR
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

 done


 if [ $NUM -ge $LIMIT ]; then
   rm -f flooding.mes flooding.click flooding_tx.click flooding_config.h
   exit 0
 fi

 let NUM=NUM+1

done

rm -f flooding.mes flooding.click flooding_tx.click flooding_config.h
