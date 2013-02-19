#!/bin/bash

if [ "x$1" != "x" ]; then
  . $1
else
  . packet_size_big.config
fi

if [ "x$RESULTFILE_PREFIX" = "x" ]; then
  RESULTFILE_PREFIX="result"
fi


DATE=`date +"%Y%m%d-%k%M"`
RESULTFILE="$RESULTFILE_PREFIX\_$DATE\.dat"


NUM=1

#echo $NO_NODES_VECTOR
#echo $PACKET_SIZE_VECTOR

#for rate in $RATES; do

rm -rf measurement_logdir
mkdir measurement_logdir

for non in $NO_NODES_VECTOR ; do

  cat sender_and_receiver.mes.tmpl | sed "s#NONODES#$non#g" > sender_and_receiver.mes

  for p_s in $PACKET_SIZE_VECTOR ; do

    for rate in $RATE_VECTOR ; do

      cat sender.click.tmpl | sed "s#PACKETSIZE_PARAMS#$p_s#g" | sed "s#RATE_PARAMS#$rate#g" | sed "s#BURST_PARAMS#$BURST_PARAMS#g" > sender.click

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

        for pr in `seq $PAR_REP`; do
         for r in `seq $REP`; do

          if [ "x$TEST" = "x1" ]; then
            echo "$non $p_s $cwmin $cw_index"
          else

            rm -rf $NUM
            mkdir $NUM

            echo "NUM=$NUM" > $NUM/params
            echo "NO_NODES=$non" >> $NUM/params
            echo "PACKETSIZE=$p_s" >> $NUM/params
            echo "BACKOFF=$cwmin" >> $NUM/params
            echo "BACKOFF_MAX=$cwmax" >> $NUM/params
            echo "SEED=$NUM" >> $NUM/params
            echo "RATE=$rate" >> $NUM/params
            cp monitor.802 $NUM

            rm -f /dev/shm/$r.mark
            (SEED=$NUM LOGLEVEL=0 FORCE_DIR=1 run_sim.sh ns sender_and_receiver.des $NUM > /dev/shm/$r.out;rm -rf $NUM;touch /dev/shm/$r.mark) &

            #rm -rf $NUM

          fi

          let NUM=NUM+1
         done

         for r in `seq $REP`; do
           while [ ! -e /dev/shm/$r.mark ]; do
             sleep 1
           done

           cat /dev/shm/$r.out | tee -a $RESULTFILE

           rm -f /dev/shm/$r.mark /dev/shm/$r.out
         done
        done

        rm -f  monitor.802
      done
    done
    rm -f sender.click
  done
  rm -f sender_and_receiver.mes
done

let NUM=NUM-1

tar cvf measurement_logdir.tar measurement_logdir
rm -rf measurement_logdir
#tar cvfj all_sim.tar.bz2 `seq $NUM` > /dev/null 2>&1

#rm -rf `seq $NUM`
