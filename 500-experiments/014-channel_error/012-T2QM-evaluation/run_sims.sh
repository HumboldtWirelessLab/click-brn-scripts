#!/bin/bash

if [ "x$SIM" = "x1" ]; then
  NO_NODES_VECTOR="2 3 4"
  #NO_NODES_VECTOR="2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25"
else
  NO_NODES_VECTOR="2 4 6 8 10"
fi

TOSTOQUEUE="0 1"

PACKET_SIZE_VECTOR="1500"

RATE_VECTOR="125"

REP=1
NUM=1

if [ "x$SIM" = "x1" ]; then
  cat placement.plm | awk '{print $1}' > nodes
else
  cp nodes.testbed nodes
fi

if [ "x$SIM" = "x1" ]; then
#  CHANNEL_MODEL="shadowing11b tworayground01b"
   CHANNEL_MODEL="tworayground01b"
#  CHANNEL_MODEL="shadowing11b"
else
  CHANNEL_MODEL="real"
fi

PKT_TARGET="USE_BROADCAST USE_UNICAST"

CURRENT_RUNMODE=DRIVER

for ttq in $TOSTOQUEUE; do

 for cm in $CHANNEL_MODEL; do

  cp backoff.des.tmpl backoff.des
  echo "" >> backoff.des
  echo "RADIO=$cm" >> backoff.des

  for target in $PKT_TARGET; do

   echo "#define $target" > config.h

   for non in $NO_NODES_VECTOR ; do

    cat backoff.mes.tmpl | sed "s#NONODES#$non#g" > backoff.mes

    for p_s in $PACKET_SIZE_VECTOR ; do

     for rate in $RATE_VECTOR ; do

        #cat sender.click.tmpl | sed "s#PACKETSIZE_PARAMS#$p_s#g" | sed "s#RATE_PARAMS#$rate#g" > sender.click

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

  rm config.h

 #ende channel model
 done
done

#let NUM=NUM-1
#tar cvfj all_sim.tar.bz2 `seq $NUM` > /dev/null 2>&1
#rm -rf `seq $NUM`

rm -f nodes config.h backoff.des

sh ./run_para_sim.sh
