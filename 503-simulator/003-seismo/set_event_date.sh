#!/bin/bash

SUB=1

echo -n "" > seismo.ctl

NUM=0

for d in `cat data/date`; do
  FINALDATE=`expr $d - $SUB`
  FINALDATE=`expr $FINALDATE`
  # \* 1000`
  echo "1 ALL DEV0 write cooperative add_alarm FF-FF-FF-FF-FF-FE $FINALDATE $NUM" >> seismo.ctl
  NUM=`expr $NUM + 1`
done