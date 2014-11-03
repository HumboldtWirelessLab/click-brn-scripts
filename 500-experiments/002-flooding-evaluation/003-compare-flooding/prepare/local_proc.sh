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

if [ "x$DESFILE" != "x" ]; then
. $DESFILE
fi

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR="/usr/src/develop/BerlinRoofNet/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/003-compare-flooding/1_MBit_1_plm_1_mst_4_2_true_4_2_4_8000_20_true_true_150_31_true_0_0_0_1_0_4_p_7_unicast_4_1/"
fi

. $RESULTDIR/params

if [ "x$ALGORITHM" = "xmst" ]; then
#echo $DIR

if [ -f $RESULTDIR/dijkstra.mat ] || [ -f $RESULTDIR/mst.mat ]; then
  exit 0
fi

STARTNODE=1

cat $RESULTDIR/placementfile.plm | NAME2NUM=1 human_readable.sh $RESULTDIR/nodes.mac > $RESULTDIR/placementfile_mst.plm

(cd $DIR; matwrapper.sh "try,dist2pdr('$RESULTDIR/placementfile_mst.plm','$RESULTDIR/dist.csv'),catch,exit(1),end,exit(0)")
sed 's#,# #g' $RESULTDIR/dist.csv > $RESULTDIR/dist.mat

(cd $DIR; matwrapper.sh "try,get_mst('$RESULTDIR/dist.mat','$RESULTDIR/mst.csv',0,$STARTNODE),catch,exit(1),end,exit(0)" 1> /dev/null)
sed 's#,# #g' $RESULTDIR/mst.csv | NUM2MAC=1 human_readable.sh $RESULTDIR/nodes.mac > $RESULTDIR/mst.mat

(cd $DIR; matwrapper.sh "try,get_dijkstra('$RESULTDIR/dist.mat','$RESULTDIR/dijkstra.csv',0,$STARTNODE),catch,exit(1),end,exit(0)" 1> /dev/null)
sed 's#,# #g' $RESULTDIR/dijkstra.csv | NUM2MAC=1 human_readable.sh $RESULTDIR/nodes.mac | sort -u > $RESULTDIR/dijkstra.mat

fi

exit 0
