#!/bin/bash

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
  "/")
      DIR=$dir
      ;;
  ".")
      DIR=$pwd/$dir
      ;;
   *)
      echo "Error while getting directory"
      exit -1
      ;;
esac

. ./linkstat_plm.des

NOPLM=1

if [ "x$1" != "x" ]; then
  NOPLM=$1
fi

for i in `seq 1 $NOPLM`; do
  if [ ! -e $i ]; then
    PREPARE_ONLY=1 run_sim.sh ns linkstat_plm.des $i
  fi
done

run_para_sim.sh

NO_NODES=`cat 1/nodes.mac | wc -l`

NUM=1

echo -n "" > placements.dat
rm -f placements_adjmat*.dat

for i in `seq 1 $NOPLM`; do

  NOCLUSTER=`cat $i/evaluation/network_info/clustersize.csv | tail -n 1 | sed "s#,# #g" | awk '{print $1}'`

  if [ $NOCLUSTER -eq 1 ]; then
    cat $i/$NODEPLACEMENTFILE | awk -v NUM=$NUM '{print NUM" "$0}' >> placements.dat
    #for g in `(cd $i/evaluation/network_info; ls graph_psr_*)`; do
    #  r=`echo $g | sed "s#_# #g" | awk '{print $3}'`
    #  s=`echo $g | sed "s#_# #g" | awk '{print $4}'`
    #  FNAME="placements_adjmat_""$r""_""$s"".dat"
    #  cat $i/evaluation/network_info/$g | awk -v NUM=$NUM '{print NUM" "$0}' >> $FNAME
    #done
    let NUM=NUM+1
  fi

done

exit 0
