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

if [ "x$SIM" = "x0" ]; then
  MODE=tb
else
  MODE=sim
fi

MAINCONFIG=config/$MODE\_main.conf

case "$1" in
  "e2e")
    CONFIG=config/$MODE\_e2e.conf
    ;;
  "simple")
    CONFIG=config/$MODE\_simple.conf
    ;;
  "unicast")
    CONFIG=config/$MODE\_unicast.conf
    ;;
  "rtscst")
    CONFIG=config/$MODE\_unicast_rtscts.conf
    ;;
  "prob")
    CONFIG=config/$MODE\_prob.conf
    ;;
  "mpr")
    CONFIG=config/$MODE\_mpr.conf
    ;;
  "mst")
    CONFIG=config/$MODE\_mst.conf
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
#else
#  echo 1_MBit_* | xargs rm -rf
fi

exit 0
