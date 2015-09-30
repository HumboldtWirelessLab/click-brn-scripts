#!/bin/sh

RTS_SCHEMES="1 2"
PACKETSIZES=`seq 30 10 90`
#PACKETSIZES="100"
INTERVAL="0"
#INTERVAL=`seq 0 5 25`

SEEDS=10
NUM=1

for scheme in $RTS_SCHEMES; do

 for psize in $PACKETSIZES; do

    for interval in $INTERVAL; do

      for s in `seq $SEEDS`; do

        cat simpleflow.ctl.tmpl | sed -e "s#SCHEME#$scheme#g" -e "s#PSIZE#$psize#g" -e "s#INTERVAL#$interval#g" > simpleflow.ctl
        echo "SEED=$s" > seed

        #mkdir $MEASUREMENTDIR
        PREPARE_ONLY=1 run_sim.sh ns simpleflow.des $NUM

        echo "SIM=1" > $NUM/params

        echo "SCHEME=$scheme" >> $NUM/params
        echo "PACKETSIZE=$psize" >> $NUM/params
        echo "INTERVAL=$interval" >> $NUM/params
        echo "SEED=$s" >> $NUM/params
        echo "NUM=$NUM" >> $NUM/params

        echo "PARAMS=\"$NUM $s $interval $psize $scheme\"" >> $NUM/params

        if [ -f ./finish ]; then
          exit
        fi

        let NUM=NUM+1

      done
    done
  done
done

sh run_para_sim.sh
