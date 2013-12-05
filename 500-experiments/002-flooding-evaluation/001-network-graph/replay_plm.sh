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

if [ "x$PLMFILE" = "x" ]; then
  PLMFILE="$DIR/../003-compare-flooding/placements_random.dat"
fi


if [ "x$1" = "x" ]; then
  NOPLM=`cat $PLMFILE | awk '{print $1}' | sort -un`
else
  NOPLM=`seq 1 $1`
fi

echo "$PLMFILE"

for i in $NOPLM; do
  if [ ! -e $i ]; then
    echo "Prepare $i."
    cat $PLMFILE | grep "^$i " | sed -e "s#^$i ##g" > replay_plm.plm
    PREPARE_ONLY=1 run_sim.sh ns replay_plm.des $i
  fi
  rm -f replay_plm.plm
done

#exit 0

run_para_sim.sh

NO_NODES=`cat 1/nodes.mac | wc -l`

NUM=1

rm -f placements_adjmat*.dat

for i in $NOPLM; do
    for g in `(cd $i/evaluation/network_info; ls graph_psr_*)`; do
      r=`echo $g | sed "s#_# #g" | awk '{print $3}'`
      s=`echo $g | sed "s#_# #g" | awk '{print $4}'`
      FNAME="placements_adjmat_""$r""_""$s"".dat"
      cat $i/evaluation/network_info/$g | awk -v NUM=$i '{print NUM" "$0}' >> $FNAME
    done
    let NUM=NUM+1

done

exit 0
