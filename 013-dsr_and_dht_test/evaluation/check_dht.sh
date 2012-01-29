#!/bin/bash

NODES=`cat $1 | grep "falconroutingtable" | sed "s#\"# #g" | awk '{print $3}' | sort -u`
NO_NODES=`echo $NODES | wc -w`

FIRST_NODE=`echo $NODES | awk '{print $1}'`
BACKLOG_PRE=`cat $1 | grep -A 3 "<falconroutingtable node=\"$FIRST_NODE" | grep "<predecessor" | sed "s#\"# #g" | awk '{print $3}'`

AC_NODE=$FIRST_NODE
PRE="NONE"

ALL_NODES=""

PRE_ERROR=0

#echo "a: $PRE b: $BACKLOG_PRE"

while [ $PRE != $BACKLOG_PRE ]; do

#next pre is only to have a clean output in th first round
PRE=`cat $1 | grep -A 3 "<falconroutingtable node=\"$AC_NODE" | grep "<predecessor" | sed "s#\"# #g" | awk '{print $3}'`
#PRE=`cat $1 | grep "0 -1 $AC_NODE" | awk '{print $4}'`

SUCC=`cat $1 | grep -A 3 "<falconroutingtable node=\"$AC_NODE" | grep "<successor" | sed "s#\"# #g" | awk '{print $3}'`
#SUCC=`cat $1 | grep "0 0 $AC_NODE" | awk '{print $4}'`

echo "$PRE $AC_NODE $SUCC" 

ALL_NODES="$ALL_NODES $SUCC"
OLD_NODE=$AC_NODE
AC_NODE=$SUCC

PRE=`cat $1 | grep -A 3 "<falconroutingtable node=\"$AC_NODE" | grep "<predecessor" | sed "s#\"# #g" | awk '{print $3}'`
#PRE=`cat $1 | grep "0 -1 $AC_NODE" | awk '{print $4}'`

if [ $PRE != $OLD_NODE ]; then
  echo "$PRE $OLD_NODE"
  PRE_ERROR=`expr $PRE_ERROR + 1`

  NO_FALCON_NODES=`echo $ALL_NODES | wc -w`

echo "No. Nodes: $NO_NODES"
echo "$NODES"
echo "BP: $BACKLOG_PRE"

echo "ALL_NODES: $NO_FALCON_NODES ERROR: $PRE_ERROR"
  exit 0
fi

done

NO_FALCON_NODES=`echo $ALL_NODES | wc -w`

echo "No. Nodes: $NO_NODES"
echo "$NODES"
echo "BP: $BACKLOG_PRE"

echo "ALL_NODES: $NO_FALCON_NODES ERROR: $PRE_ERROR"
