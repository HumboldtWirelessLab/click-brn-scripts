#!/bin/sh

if [ "x$LIMIT" = "x" ]; then
  LIMIT=`cat nodes | grep -v "#" | wc -l`
fi

NUM=1

for i in `cat nodes | grep -v "#"`; do
  if [ "x$SIM" = "x" ]; then
    cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" | sed "s#LOGDIR#/tmp#g" > flooding.mes
  else
    cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" > flooding.mes
  fi

  cat flooding_tx.click | grep -v "flooding_init" > flooding.click

  if [ "x$SIM" = "x" ]; then
    RUNMODE=REBOOT run_measurement.sh flooding.des $NUM
  else
    run_sim.sh ns flooding.des $NUM
  fi

  if [ $NUM -ge $LIMIT ]; then
    rm -f flooding.mes flooding.click
    exit 0
  fi

done

rm -f flooding.mes flooding.click
