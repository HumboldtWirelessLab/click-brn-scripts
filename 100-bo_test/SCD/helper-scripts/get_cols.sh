#!/bin/bash

if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi


DOUBLED_COLS=`cat $DIR/receiver.tr | grep COL | wc -l`
REAL_COLS=`echo $DOUBLED_COLS | awk '{print int($1 / 2)}'`

echo $REAL_COLS
