#!/bin/sh

if [ "x$1" = "x--help" ]; then
  echo "X=xlen Y=ylen N=no_nodes B=no_boxes L=len_between_boxes LN=no_nodes_on_bridge $0"
fi

#NODES=`cat $2 | grep -v "#" | awk '{print $1}' | uniq`
#NODEDIST=$3

if [ "x$NODEPLACEMENTOPTS" != "x" ]; then
  #echo "X=xlen Y=ylen N=no_nodes B=no_boxes L=len_between_boxes LN=no_nodes_on_bridge"
  N=`cat $1 | grep -v "#" | awk '{print $1}' | wc -l`
  X=`echo $NODEPLACEMENTOPTS | awk '{print $1}'`
  Y=`echo $NODEPLACEMENTOPTS | awk '{print $2}'`
  B=`echo $NODEPLACEMENTOPTS | awk '{print $3}'`
  L=`echo $NODEPLACEMENTOPTS | awk '{print $4}'`
  LN=`echo $NODEPLACEMENTOPTS | awk '{print $5}'`
fi


NO_NODES=1
let BRIDGE_MID=Y/2

#place first node
NODE=`cat $1 | grep -v "#" | awk '{print $1}' | head -n $NO_NODES | tail -n 1`
echo "$NODE 0 $BRIDGE_MID 0"

#anzahl der Bridge Knoten
let NO_BR=B-1
let NO_B_NODES=NO_BR*LN

#Länge der Teilstücke (bruecke)
let NO_BLOCKS_ON_B=LN-1
let D_B_N=L/NO_BLOCKS_ON_B

let BOX_NODES=N-NO_B_NODES
let NODES_PER_BOX=BOX_NODES/B

#echo "$NO_B_NODES"

BRIDGE_START=$X
for b in `seq $NO_BR`; do
  BR_POS=$BRIDGE_START
  for bn in `seq $LN`; do
    let NO_NODES=NO_NODES+1
    NODE=`cat $1 | grep -v "#" | awk '{print $1}' | head -n $NO_NODES | tail -n 1`
    echo "$NODE $BR_POS $BRIDGE_MID 0"
    let BR_POS=BR_POS+D_B_N
  done
  let BRIDGE_START=BRIDGE_START+X
  let BRIDGE_START=BRIDGE_START+L
done


BOX_START=0

for b in `seq $B`; do

  for bn in `seq $NODES_PER_BOX`; do

    #first node in first box is already placed
    if [ $b -eq 1 ] && [ $bn -eq 1 ]; then
      continue;
    fi

    R=`head -1 /dev/urandom | od -N 2 -t uL | head -n 1 | awk '{print $2}'`
    XP=`expr $R % $X`
    R=`head -1 /dev/urandom | od -N 2 -t uL | head -n 1 | awk '{print $2}'`
    YP=`expr $R % $Y`

    let XP=XP+BOX_START
    let NO_NODES=NO_NODES+1
    NODE=`cat $1 | grep -v "#" | awk '{print $1}' | head -n $NO_NODES | tail -n 1`
    echo "$NODE $XP $YP 0"

  done

  let BOX_START=BOX_START+X
  let BOX_START=BOX_START+L

done

#handle restl nodes

let MISSED_NODES=N-NO_NODES

if [ $MISSED_NODES -gt 0 ]; then

  for n in `seq $MISSED_NODES`; do

    R=`head -1 /dev/urandom | od -N 2 -t uL | head -n 1 | awk '{print $2}'`
    BOX=`expr $R % $B`
    R=`head -1 /dev/urandom | od -N 2 -t uL | head -n 1 | awk '{print $2}'`
    XP=`expr $R % $X`
    R=`head -1 /dev/urandom | od -N 2 -t uL | head -n 1 | awk '{print $2}'`
    YP=`expr $R % $Y`

    let B_L_SUM_LEN=L+X
    let BOX_START=B_L_SUM_LEN*BOX

    let XP=XP+BOX_START
    let NO_NODES=NO_NODES+1
    NODE=`cat $1 | grep -v "#" | awk '{print $1}' | head -n $NO_NODES | tail -n 1`
    echo "$NODE $XP $YP 0"
  done

fi
