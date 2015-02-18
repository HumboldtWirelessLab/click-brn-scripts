#!/bin/bash

if [ "x$1" = "x" ]; then
  echo "Use $0 e2e|simple|unic"
  exit 0
fi

if [ $# -gt 1 ]; then

  for i in $@; do
    $0 $i
  done

fi

MAINCONFIG=config/main.conf

case "$1" in
  "e2e")
    CONFIG=config/sim_e2e.conf
    ;;
  "simple")
    CONFIG=config/sim_simple.conf
    ;;
  "unicast")
    CONFIG=config/sim_unicast.conf
    ;;
  "rtscst")
    CONFIG=config/sim_unicast_rtscts.conf
    ;;
  "prob")
    CONFIG=config/sim_prob.conf
    ;;
  "mpr")
    CONFIG=config/sim_mpr.conf
    ;;
  "mst")
    CONFIG=config/sim_mst.conf
    ;;
  *)
    echo "Unknown option: $1"
    exit 0
    ;;
esac

CONFIG=$CONFIG MAINCONFIG=$MAINCONFIG ./start.sh

DATESTRING=`date +%Y%m%d`
DIRSTRING=$DATESTRING-$1

(cd evaluation; ./eval_all.sh ..; mkdir $DIRSTRING; mv *.dat $DIRSTRING)

if  [ -e /mnt/data/flooding/ ]; then
  mkdir $1
  mv 1_MBit_* $1
  tar cfv /mnt/data/flooding/$1.tar $1
  rm -rf $1
else
  echo 1_MBit_* | xargs rm -rf
fi

exit 0
