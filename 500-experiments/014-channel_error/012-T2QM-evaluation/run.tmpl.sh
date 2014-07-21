#!/bin/bash

if [ "x$SIM" = "x1" ]; then
  NO_NODES_VECTOR=SENDERS
  #NO_NODES_VECTOR="2 3 4"
  #NO_NODES_VECTOR="1 2 4 6 8 10 12 14 16 18 20"
  #NO_NODES_VECTOR="1 5 10 15 20 25 30"
  #NO_NODES_VECTOR="1 2 4"
  #NO_NODES_VECTOR="1 2 5 10 20 30"
  #NO_NODES_VECTOR="5 10 20 30"
  #NO_NODES_VECTOR="1 2 5 10"
  #NO_NODES_VECTOR="2 4 6 8"
  #NO_NODES_VECTOR="1 2 4 6 8 10"
  #NO_NODES_VECTOR="2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25"
  #NO_NODES_VECTOR="2 4 6 8 10 12 14 16"
  #NO_NODES_VECTOR="1 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30"
else
  NO_NODES_VECTOR="2 4 6 8 10"
fi

#TOSTOQUEUE="0 2 3 4 5 6 7"
#TOSTOQUEUE="0 3 5"
#TOSTOQUEUE="0 2 3 4"
#TOSTOQUEUE="0 3"
TOSTOQUEUE="8"

PACKET_SIZE_VECTOR="1500"
#PACKET_SIZE_VECTOR="750 1500"
#PACKET_SIZE_VECTOR="375 750 1500"
#PACKET_SIZE_VECTOR="500 1000 1500"
#PACKET_SIZE_VECTOR="100 200 400 600 800 1000 1250 1500"
#PACKET_SIZE_VECTOR="100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500"
#PACKET_SIZE_VECTOR="200 400 800 1000 1250 1500"
#PACKET_SIZE_VECTOR="125 350 700 1400"
#PACKET_SIZE_VECTOR="150 750 1500"


RATE_VECTOR="125"

REP=1
NUM=1

#if [ "x$SIM" = "x1" ]; then
  #cat placement.plm | awk '{print $1}' > nodes
#else
#  cp nodes.testbed nodes
#fi

if [ "x$SIM" = "x1" ]; then
#   CHANNEL_MODEL="shadowing11b tworayground01b"
#    CHANNEL_MODEL="shadowing01b tworayground01b"
#   CHANNEL_MODEL="shadowing11b"
#    CHANNEL_MODEL="shadowing01b"
   CHANNEL_MODEL="tworayground01b"
else
  CHANNEL_MODEL="real"
fi

#PKT_TARGET="USE_BROADCAST USE_UNICAST"
PKT_TARGET="USE_UNICAST"


CURRENT_RUNMODE=DRIVER

for ttq in $TOSTOQUEUE; do

 for cm in $CHANNEL_MODEL; do

  cp backoff.des.tmpl backoff.des
  echo "" >> backoff.des
  echo "RADIO=$cm" >> backoff.des

  for target in $PKT_TARGET; do

   echo "#define $target" > config.click
   echo "#define TOS2QUEUEMAPPER_STRATEGY $ttq" >> config.click

   for non in $NO_NODES_VECTOR ; do

    cat backoff.mes.tmpl | sed "s#NONODES#$non#g" > backoff.mes

    #echo -n "" > simpleflow.ctl
    #let LAST_SENDER=non+1
    #for i in `seq 2 $LAST_SENDER`; do
    #  echo "1  sk$i   ath0  write sf  add_flow  sk$i:eth  00:00:00:00:00:01 0  1500 0 30000 true 1 0" >> simpleflow.ctl
    #done

    for p_s in $PACKET_SIZE_VECTOR ; do

     for rate in $RATE_VECTOR ; do

        cat sender.click.tmpl | sed "s#PACKETSIZE_PARAMS#$p_s#g" | sed "s#RATE_PARAMS#$rate#g" > sender.click

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
                SEED=$NUM LOGLEVEL=0 FORCE_DIR=1 PREPARE_ONLY=1 run_sim.sh ns backoff.des $NUM
              else
                RUNMODE=$CURRENT_RUNMODE run_measurement.sh backoff.des $NUM
              fi

              echo "NUM=$NUM" > $NUM/params
              echo "NO_NODES=$non" >> $NUM/params
              echo "PACKETSIZE=$p_s" >> $NUM/params
              echo "TOS2QUEUEMAPPER_STRATEGY=$ttq" >> $NUM/params
              echo "SEED=$NUM" >> $NUM/params
              echo "RATE=$rate" >> $NUM/params
              echo "TARGET=$target" >> $NUM/params
              echo "CHANNEL_MODEL=$cm" >> $NUM/params
              echo "REP=$r" >> $NUM/params
              cp monitor $NUM
            fi

          fi

          let NUM=NUM+1

          if [ -f finish ]; then
            exit 0
          fi
        done

        #rm -f monitor.802

     done
     #rm -f sender.click
    done
    rm -f backoff.mes
   done

  #ende target
  done

  rm config.click

 #ende channel model
 done
done

#let NUM=NUM-1
#tar cvfj all_sim.tar.bz2 `seq $NUM` > /dev/null 2>&1
#rm -rf `seq $NUM`

rm -f nodes config.h backoff.des

sh ./run_para_sim.sh

#(cd evaluation; ./eval_all.sh)

exit 0
