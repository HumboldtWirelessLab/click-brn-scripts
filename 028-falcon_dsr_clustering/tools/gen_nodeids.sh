#!/bin/sh

if [ $# -eq 0 ]; then
  echo "Use $0 no_nodes no_cluster"
  exit 0
fi

NO_NODES=$1
NO_CLUSTER=$2

MODE=$3
SIDELEN=$4

AVG_NODES_PER_CLUSTER=`expr $NO_NODES / $NO_CLUSTER`

NODE=1
CLUSTER=1
NODE_IN_CLUSTER=1;

CLUSTER_ID=0
NODEID_IN_CLUSTER=0

CLUSTERID_PLUS=`expr 65536 / $NO_CLUSTER`
NODEID_PLUS=`expr $CLUSTERID_PLUS / $AVG_NODES_PER_CLUSTER`


if [ "x$MODE" = "xns" ]; then
  cat simple_head.tcl | sed "s#NODECOUNT#$NO_NODES#g" | sed "s#SIDELEN#$SIDELEN#g" > simple.tcl
else
  echo "NON: $NO_NODES NOC: $NO_CLUSTER CPN: $AVG_NODES_PER_CLUSTER CIDP: $CLUSTERID_PLUS NIDP: $NODEID_PLUS"
fi

while [ $NODE -le $NO_NODES ]; do
  
  ID=`expr $CLUSTER_ID + $NODEID_IN_CLUSTER`
  
  CID=`expr $ID / 256`
  NID=`expr $ID % 256`

  if [ "x$MODE" = "xns" ]; then
    NSNODE=`expr $NODE - 1`
    printf "\$ns_ at  0.0 \"puts \\\\\\\"\\[\\[\$node_($NSNODE) entry\\] writehandler dht/dhtrouting node_id \\\\\\\"%02x%02x0000000000000000000000000000 128\\\\\\\" \\\]\\\\\\\"\"\n" $CID $NID >> simple.tcl
  else
    echo "$NODE $CLUSTER $NODE_IN_CLUSTER $CID $NID"
#    printf "%02x %02x\n" $CID $NID
  fi

  NODE=`expr $NODE + 1`
  NODE_IN_CLUSTER=`expr $NODE_IN_CLUSTER + 1`
  NODEID_IN_CLUSTER=`expr $NODEID_IN_CLUSTER + $NODEID_PLUS`
  
  if [ $NODE_IN_CLUSTER -gt $AVG_NODES_PER_CLUSTER ]; then
    CLUSTER=`expr $CLUSTER + 1`
    NODEID_IN_CLUSTER=0
    NODE_IN_CLUSTER=1
    CLUSTER_ID=`expr $CLUSTER_ID + $CLUSTERID_PLUS`
    if [ $CLUSTER -eq $NO_CLUSTER ]; then
      AVG_NODES_PER_CLUSTER=`expr $NO_NODES - $NODE + 1`
      NODEID_PLUS=`expr $CLUSTERID_PLUS / $AVG_NODES_PER_CLUSTER`
    fi
  fi

done


if [ "x$MODE" = "xns" ]; then
  cat simple_tail.tcl >> simple.tcl
fi

#printf "%02x\n" 5