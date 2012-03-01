#!/bin/sh

if [ "x$1" = "x" ] || [ "x$2" = "x" ]; then
  echo "Use $0 nonodes noflows"
  exit 0
fi

NONODES=$1
NOFLOWS=$2

rm -f dsr_simpleflow.mes dsr_simpleflow.ctl dsr_simpleflow.des dsr_simpleflow.click

# FIRSTNODE:eth LASTNODE:eth 500 100 2 15000 true

cat dsr_simpleflow.mes.tmpl | sed "s#NONODES#$NONODES#g" > dsr_simpleflow.mes

TIME=110

for f in `seq $NOFLOWS`; do
  SRCNODE=`expr \( $RANDOM % $NONODES \) + 1`
  DSTNODE=$SRCNODE
  
  while [ $SRCNODE -eq $DSTNODE ]; do
    DSTNODE=`expr \( $RANDOM % $NONODES \) + 1`
  done

  echo "$TIME sk$SRCNODE ath0 write sf add_flow sk$SRCNODE:eth sk$DSTNODE:eth 500 100 2 5000 true" >> dsr_simpleflow.ctl
  TIME=`expr $TIME + 10`
  echo "$TIME sk$SRCNODE ath0 write sf add_flow sk$SRCNODE:eth sk$DSTNODE:eth 500 100 2 5000 false" >> dsr_simpleflow.ctl
  TIME=`expr $TIME + 5`
done

cat dsr_simpleflow.des.tmpl | sed "s#ENDTIME#$TIME#g" > dsr_simpleflow.des

TIME=`expr $TIME - 1`

cat dsr_simpleflow.click.tmpl | sed "s#FLOWENDTIME#$TIME#g" > dsr_simpleflow.click

run_sim.sh

rm -f dsr_simpleflow.mes dsr_simpleflow.ctl dsr_simpleflow.des dsr_simpleflow.click

exit 0

