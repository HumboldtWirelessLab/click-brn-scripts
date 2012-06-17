#!/bin/bash

#NO_NODES_VECTOR="2 3 4 5 6 7"
#PACKET_SIZE_VECTOR="100 250 500 1000 1500"
NO_NODES_VECTOR="5"
PACKET_SIZE_VECTOR="1500"

BO_START_MIN=4
BO_START_MAX=16
BO_END_MIN=128
MUL_STEP=1
ADD_STEP=16

NUM=1

#echo $NO_NODES_VECTOR
#echo $PACKET_SIZE_VECTOR

for non in $NO_NODES_VECTOR ; do

  cat sender_and_receiver.mes.tmpl | sed "s#NONODES#$non#g" > sender_and_receiver.mes
  for p_s in $PACKET_SIZE_VECTOR ; do

    cat sender.click.tmpl | sed "s#PACKETSIZE_PARAMS#$p_s#g" > sender.click

    BACKOFF=$BO_START_MIN
    BACKOFF_MAX=$BO_START_MAX

    rm -f  monitor.802

    while [ $BACKOFF -le $BO_END_MIN ]; do

      cp monitor.802.tmpl  monitor.802

      B=$BACKOFF

      echo -n "CWMIN=\"" >>  monitor.802
     
      for i in `seq 4`; do
        b=`expr $B - 1`
        echo -n "$b "  >>  monitor.802
        B=`expr $B \* $MUL_STEP + $ADD_STEP`
      done
      echo "\""  >>  monitor.802

      B_M=$BACKOFF_MAX

      echo -n "CWMAX=\""  >>  monitor.802
      for i in `seq 4`; do
        b=`expr $B_M - 1`
        echo -n "$b "  >>  monitor.802
        B_M=`expr $B_M \* $MUL_STEP + $ADD_STEP`
      done
      echo "\""  >>  monitor.802

      echo "AIFS=\"2 2 2 2\""  >>  monitor.802

      BACKOFF=`expr $BACKOFF \* 2`
      BACKOFF_MAX=`expr $BACKOFF_MAX \* 2`

      if [ "x$TEST" = "x1" ]; then
        echo "$non $p_s $BACKOFF"
      else 

        rm -rf $NUM
	mkdir $NUM
	
        echo "NUM=$NUM" > $NUM/params
        echo "NO_NODES=$non" >> $NUM/params
        echo "PACKETSIZE=$p_s" >> $NUM/params
        echo "BACKOFF=$BACKOFF" >> $NUM/params
        echo "BACKOFF_MAX=$non" >> $NUM/params
	
        LOGLEVEL=0 FORCE_DIR=1 run_sim.sh ns sender_and_receiver.des $NUM
  
        cp monitor.802 $NUM
      
      fi
  
      let NUM=NUM+1
  
      rm -f  monitor.802
    done
    rm -f sender.click
  done
  rm -f sender_and_receiver.mes
done

