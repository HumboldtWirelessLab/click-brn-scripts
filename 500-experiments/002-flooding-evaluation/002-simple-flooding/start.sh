#!/bin/sh

if [ "x$LIMIT" = "x" ]; then
  LIMIT=`cat nodes | grep -v "#" | wc -l`
fi

NUM=1

if [ "x$DATARATE" = "x" ]; then
  echo "Set DATARATE. Use DATARATE=x ./start.sh"
  exit 1
fi

CURRENTRUNMODE=REBOOT

RUNMODE_RESET_COUNT=0

for i in `cat nodes | grep -v "#"`; do

  if [ "x$SIM" = "x" ]; then
    MEASUREMENTDIR="$DATARATE""_MBit_"$NUM
  else
    MEASUREMENTDIR=$NUM
  fi

  if [ ! -e $MEASUREMENTDIR ]; then
    if [ "x$SIM" = "x" ]; then
      MAC=`cat nodes.mac | grep $i | awk '{print $3}'`
    else
      MAC=`cat nodes.mac.sim | grep $i | awk '{print $3}'`
    fi

    if [ "x$SIM" = "x" ]; then
      cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" | sed "s#LOGDIR#/tmp#g" > flooding.mes
    else
      cat flooding.mes.tmpl | sed "s#TXFLOODNODE#$i#g" > flooding.mes
    fi

    cat flooding_tx.click.tmpl | grep -v "flooding_init" > flooding.click
    cat flooding_tx.click.tmpl | sed "s#NODEMACADDR#$MAC#g" > flooding_tx.click

    if [ "x$SIM" = "x" ]; then
      RUNMODE=$CURRENTRUNMODE run_measurement.sh flooding.des $MEASUREMENTDIR

      CURRENTRUNMODE=CLICK
      let RUNMODE_RESET_COUNT=RUNMODE_RESET_COUNT+1

      if [ $RUNMODE_RESET_COUNT -eq 10 ]; then
        CURRENTRUNMODE=REBOOT
        RUNMODE_RESET_COUNT=0
      fi

    else
      run_sim.sh ns flooding.des $MEASUREMENTDIR
    fi

    if [ $NUM -ge $LIMIT ]; then
      rm -f flooding.mes flooding.click flooding_tx.click
      exit 0
    fi
  fi

  let NUM=NUM+1

done

rm -f flooding.mes flooding.click flooding_tx.click
