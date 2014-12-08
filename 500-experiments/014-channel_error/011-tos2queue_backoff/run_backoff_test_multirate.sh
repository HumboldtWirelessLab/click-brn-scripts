#!/bin/bash

#1. Queue
#Queue 0, 2, 3 wird errechnet
boa=('0' '32' '64' '128' '128' '128' '256' '256' '256' '256' '256' '256' '256' '512' '512' '512' '512' '512' '512' '512' '512' '512' '512' '512' '512' '512');

if [ "x$SIM" = "x1" ]; then
  NO_NODES_VECTOR="2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25"
#  NO_NODES_VECTOR="2 10 25"
else
  NO_NODES_VECTOR="2 4 6 8 10"
fi

TOSTOQUEUE="0 1"
#TOSTOQUEUE="1"

PACKET_SIZE_VECTOR="1500"

RATE_VECTOR="125"

REP=1
NUM=1

if [ "x$PLACEMENTFILE" = "x" ]; then
  PLACEMENTFILE=placementfile.plm.small
fi

cp $PLACEMENTFILE placementfile.plm

if [ "x$SIM" = "x1" ]; then
  cat placementfile.plm | awk '{print $1}' > nodes
else
  cp nodes.testbed nodes
fi

if [ "x$SIM" = "x1" ]; then
  CHANNEL_MODEL="shadowing tworayground"
#  CHANNEL_MODEL="shadowing"
else
  CHANNEL_MODEL="real"
fi

PKT_TARGET="USE_BROADCAST USE_UNICAST"

CURRENT_RUNMODE=DRIVER

for ttq in $TOSTOQUEUE; do

for cm in $CHANNEL_MODEL; do

 cp sender_and_receiver.des.tmpl sender_and_receiver.des
 echo "" >> sender_and_receiver.des
 echo "RADIO=$cm" >> sender_and_receiver.des

 for target in $PKT_TARGET; do

  echo "#define $target" > config.h

  for non in $NO_NODES_VECTOR ; do

   cat sender_and_receiver.mes.tmpl | sed "s#NONODES#$non#g" > sender_and_receiver.mes

   for p_s in $PACKET_SIZE_VECTOR ; do

    for rate in $RATE_VECTOR ; do

      cat sender.click.tmpl | sed "s#PACKETSIZE_PARAMS#$p_s#g" | sed "s#RATE_PARAMS#$rate#g" > sender.click

      rm -f monitor.802

        cp monitor.802.tmpl monitor.802

        if [ $ttq -eq 0 ]; then
          echo "CWMIN=\"15 15 15 15\"" >>  monitor.802
          echo "CWMAX=\"1023 1023 1023 1023\""  >>  monitor.802
          echo "AIFS=\"2 2 2 2\""  >>  monitor.802
          echo "#define TOS2QUEUEMAPPER_STRATEGY 0" >> config.h
        else
          #echo "CWMIN=\"15 15 15 15\"" >>  monitor.802
          cwmin=${boa[$non]};
          #echo "$cwmin"
          let cwmin=cwmin/2;
          echo -n "CWMIN=\"" >>  monitor.802

          for i in `seq 4`; do
            let  cwmin_set=cwmin-1
            echo -n "$cwmin_set" >>  monitor.802
            if [ $i -lt 4 ]; then
              echo -n " " >>  monitor.802
            fi
            let cwmin=cwmin\*2
          done

          echo "\"" >>  monitor.802
          echo "CWMAX=\"2047 2047 2047 2047\""  >>  monitor.802
          echo "AIFS=\"2 2 2 2\""  >>  monitor.802
          echo "#define TOS2QUEUEMAPPER_STRATEGY 1" >> config.h
        fi

        for r in `seq $REP`; do

          if [ "x$TEST" = "x1" ]; then
            echo "$non $p_s $ttq"
          else

            if [ -e $NUM ]; then
              if [ "x$SIM" = "x1" ] && [ ! -e $NUM/time.stats ]; then
                rm -rf $NUM
              fi
            fi

            if [ ! -e $NUM ]; then
              if [ "x$SIM" = "x1" ]; then
                SEED=$NUM LOGLEVEL=0 FORCE_DIR=1 PREPARE_ONLY=1 run_sim.sh ns sender_and_receiver.des $NUM
              else
                RUNMODE=$CURRENT_RUNMODE run_measurement.sh sender_and_receiver.des $NUM
              fi

              echo "NUM=$NUM" > $NUM/params
              echo "NO_NODES=$non" >> $NUM/params
              echo "PACKETSIZE=$p_s" >> $NUM/params
              echo "BACKOFF=$cwmin" >> $NUM/params
              echo "BACKOFF_MAX=$cwmax" >> $NUM/params
              echo "TOS2QUEUEMAPPER_STRATEGY=$ttq" >> $NUM/params
              echo "SEED=$NUM" >> $NUM/params
              echo "RATE=$rate" >> $NUM/params
              echo "TARGET=$target" >> $NUM/params
              echo "CHANNEL_MODEL=$cm" >> $NUM/params
              cp monitor.802 $NUM
            fi

          fi

          let NUM=NUM+1

          if [ -f finish ]; then
            exit 0
          fi
        done

        rm -f  monitor.802

    done
    rm -f sender.click
   done
   rm -f sender_and_receiver.mes
  done

 #ende target
 done

 rm config.h

#ende channel model
done
done

#let NUM=NUM-1
#tar cvfj all_sim.tar.bz2 `seq $NUM` > /dev/null 2>&1
#rm -rf `seq $NUM`

rm -f nodes config.h sender_and_receiver.des

sh ./run_para_sim.sh
