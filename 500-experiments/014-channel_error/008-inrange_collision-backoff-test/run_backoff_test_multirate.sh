#!/bin/bash

CWMIN=( 4  8 12 16 20 24 28 32 40 48  56  64  80  96 112 128 160 192 224 256 288 320 352 384 416 448 480 512 1024 2048 )
#CWMAX=( 8 16 24 32 40 48 56 64 80 96 112 128 160 192 224 256 320 384 448 512 )
CWMAX=( 4  8 12 16 20 24 28 32 40 48  56  64  80  96 112 128 160 192 224 256 288 320 352 384 416 448 480 512 1024 2048)

if [ "x$SIM" = "x1" ]; then
  NO_NODES_VECTOR="2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25"
#  NO_NODES_VECTOR="2 15 25"
#  NO_NODES_VECTOR="2"
else
  NO_NODES_VECTOR="2 4 6 8 10"
fi

PACKET_SIZE_VECTOR="500 1500 2000"
#PACKET_SIZE_VECTOR="1500"
#PACKET_SIZE_VECTOR="1500 500"
RATE_VECTOR="125"

REP=1
NUM=1

#echo $NO_NODES_VECTOR
#echo $PACKET_SIZE_VECTOR

#for rate in $RATES; do

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
  CHANNEL_MODEL="shadowing11b tworayground01b"
else
  CHANNEL_MODEL="real"
fi

PKT_TARGET="USE_BROADCAST USE_UNICAST"

CURRENT_RUNMODE=DRIVER

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

      rm -f  monitor.802

      #echo ${#CWMIN[@]}

      for cw_index in `seq ${#CWMIN[@]}` ; do

        cp monitor.802.tmpl monitor.802

        let cwi=cw_index-1

        cwmin=${CWMIN[$cwi]}
        cwmax=${CWMAX[$cwi]}

        echo -n "CWMIN=\"" >>  monitor.802

        for i in `seq 4`; do
          echo -n "$cwmin "  >>  monitor.802
        done
        echo "\""  >>  monitor.802

        echo -n "CWMAX=\""  >>  monitor.802
        for i in `seq 4`; do
          echo -n "$cwmax "  >>  monitor.802
        done
        echo "\""  >>  monitor.802

        echo "AIFS=\"2 2 2 2\""  >>  monitor.802

        for r in `seq $REP`; do

          if [ "x$TEST" = "x1" ]; then
            echo "$non $p_s $cwmin $cw_index"
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

#let NUM=NUM-1
#tar cvfj all_sim.tar.bz2 `seq $NUM` > /dev/null 2>&1
#rm -rf `seq $NUM`

rm -f nodes config.h sender_and_receiver.des

sh ./run_para_sim.sh
