#!/bin/bash

if [ "x$SIM" = "x1" ]; then
  NO_NODES_MIN=2
  NO_NODES_MAX=10
  NO_NODES_STEP=2
  NO_NODES_VECTOR=`seq $NO_NODES_MIN $NO_NODES_STEP $NO_NODES_MAX`
else
  NO_NODES_VECTOR="2 4 6 8 10"
fi

#define BACKOFF_STRATEGY_OFF                             0 /* default */
#define BACKOFF_STRATEGY_DIRECT                          1
#define BACKOFF_STRATEGY_MAX_THROUGHPUT                  2
#define BACKOFF_STRATEGY_BUSY_AWARE                      3
#define BACKOFF_STRATEGY_TARGET_PACKETLOSS               4
#define BACKOFF_STRATEGY_LEARNING                        5
#define BACKOFF_STRATEGY_TARGET_DIFF_RXTX_BUSY           6
#define BACKOFF_STRATEGY_NEIGHBOURS                      7
#define BACKOFF_STRATEGY_CONSTANT                        8
#define BACKOFF_STRATEGY_TX_AWARE                        9
#define BACKOFF_STRATEGY_FLOODING                       10

#TOSTOQUEUE="0 1 2 3 4 5 6 7 8 9"
TOSTOQUEUE="0 9"


#define QUEUEMAPPING_NEXT_BIGGER   0
#define QUEUEMAPPING_NEXT_SMALLER  1
#define QUEUEMAPPING_PROBABILISTIC 2
#define QUEUEMAPPING_GRAVITATION   3
#define QUEUEMAPPING_DIRECT        4

#QUEUEMAPPING="0 1 2 3 4"
QUEUEMAPPING="0 1"

#define QUEUEMAPPING_DIFFQUEUE_EXP     0  /* mul with 2 every step but also add 1 */
#define QUEUEMAPPING_DIFFQUEUE_MUL     1
#define QUEUEMAPPING_DIFFQUEUE_ADD     2
#define QUEUEMAPPING_DIFFQUEUE_FIB     3

#MAC_BACKOFF_SCHEME_EXPONENTIAL = 1
#MAC_BACKOFF_SCHEME_FIBONACCI = 2

#MAC_BACKOFF_SCHEMES="1 2"
MAC_BACKOFF_SCHEMES="1"

PACKET_SIZE_MIN=1500
PACKET_SIZE_MAX=1500
PACKET_SIZE_STEP=1
PACKET_SIZE_VECTOR=`seq $PACKET_SIZE_MIN $PACKET_SIZE_STEP $PACKET_SIZE_MAX`

RATE_VECTOR="125"

REP=1

if [ "x$CONFIGFILE" != "x" ]; then
  if [ -f $CONFIGFILE ]; then
  . $CONFIGFILE
  fi
fi

NUM=1

if [ "x$SIM" = "x1" ]; then
  #cat placement.plm | awk '{print $1}' > nodes
  echo -n ""
else
  cp nodes.testbed nodes
fi

if [ "x$SIM" = "x1" ]; then
    #CHANNEL_MODEL="tworayground"
    CHANNEL_MODEL="shadowing"
else
  CHANNEL_MODEL="real"
fi

#PKT_TARGET="USE_BROADCAST USE_UNICAST"
PKT_TARGET="USE_UNICAST"


CURRENT_RUNMODE=DRIVER

for mbs in $MAC_BACKOFF_SCHEMES; do
for ttq in $TOSTOQUEUE; do

 if [ $ttq -le 1 ]; then
   #"direct" and "off" use the queue as they are so just "search" next bigger
   #next bigger
   FINQUEUEMAPPING="0"
 else
   FINQUEUEMAPPING=$QUEUEMAPPING
 fi

 for qm in $FINQUEUEMAPPING; do

 if [ "x$BO_WIN" = "x" ]; then
   FIN_BO_WIN=0
 else
   FIN_BO_WIN=$BO_WIN
 fi

 for bowinsz in $FIN_BO_WIN; do

 for cm in $CHANNEL_MODEL; do

  cp backoff.des.tmpl backoff.des
  echo "" >> backoff.des
  echo "RADIO=$cm" >> backoff.des

  for target in $PKT_TARGET; do

   echo "#define $target" > config.click
   echo "#define TOS2QUEUEMAPPER_MAC_BO_SCHEME $mbs" >> config.click
   echo "#define TOS2QUEUEMAPPER_STRATEGY $ttq" >> config.click
   echo "#define TOS2QUEUEMAPPER_QUEUEMAPPING $qm" >> config.click

   if [ $qm -ne 4 ]; then    # Not direct
     if [ $mbs -eq 1 ]; then # exponential mac
       echo "#define TOS2QUEUEMAPPER_QUEUEMODE 0" >> config.click
       echo "#define TOS2QUEUEMAPPER_CWMINMAXMODE 0" >> config.click
     else                    #fib
       echo "#define TOS2QUEUEMAPPER_QUEUEMODE 3" >> config.click
       echo "#define TOS2QUEUEMAPPER_CWMINMAXMODE 3" >> config.click
     fi
   else # direct
     #use add with 0 diff
     echo "#define TOS2QUEUEMAPPER_QUEUEMODE 2" >> config.click
     echo "#define TOS2QUEUEMAPPER_CWMINMAXMODE 2" >> config.click
     echo "#define TOS2QUEUEMAPPER_QUEUEVAL 0" >> config.click
     echo "#define TOS2QUEUEMAPPER_CWMINMAXVAL 0" >> config.click
     #echo "#define TOS2QUEUEMAPPER_QUEUEMODE 0" >> config.click
     #echo "#define TOS2QUEUEMAPPER_CWMINMAXMODE 0" >> config.click
     #echo "#define TOS2QUEUEMAPPER_QUEUEVAL 1" >> config.click
     #echo "#define TOS2QUEUEMAPPER_CWMINMAXVAL 7" >> config.click
   fi

   if [ $bowinsz -ne 0 ]; then
     echo "#define BOCONST_VALUE $bowinsz" >> config.click
   fi

   for non in $NO_NODES_VECTOR ; do

    cat backoff.mes.tmpl | sed "s#NONODES#$non#g" > backoff.mes

    for p_s in $PACKET_SIZE_VECTOR ; do

     for rate in $RATE_VECTOR ; do

        cat sender.click.tmpl | sed "s#PACKETSIZE_PARAMS#$p_s#g" | sed "s#RATE_PARAMS#$rate#g" | sed "s#TOS2QMQUEUEMAPPING#$qm#g" > sender.click

        for r in `seq $REP`; do

          if [ "x$TEST" = "x1" ]; then
            echo "$non $p_s $ttq $qm"
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
              echo "QUEUEMAPPING=$qm" >> $NUM/params
              echo "MACBOSCHEME=$mbs" >> $NUM/params
              echo "FIXEDBO=$bowinsz" >> $NUM/params
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
 done
done
done

#let NUM=NUM-1
#tar cvfj all_sim.tar.bz2 `seq $NUM` > /dev/null 2>&1
#rm -rf `seq $NUM`

rm -f nodes config.h backoff.des sender.click simpleflow.ctl

run_para_sim.sh

if [ "x$DISABLE_EVAL" != "x1" ]; then
  (cd evaluation; ./eval_all.sh)
fi

exit 0
