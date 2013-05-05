#!/bin/bash

for i in `ls -d [0-9]*`; do
  rm -f $i/receiver.xml
  if [ -f $i/measurement.log.bz2 ]; then
    (cd $i; bzip2 -d measurement.log.bz2)
  fi
  DIR=$PWD
  MODE=sim SIM=ns CONFIGDIR=$DIR/ CONFIGFILE=$DIR/$i/sender_and_receiver.des.ns2 RESULTDIR=$DIR/$i ./evaluation/eval.sh
  (cd $i; bzip2 -z measurement.log)
done

(cd ./evaluation/; ./eval_all.sh ../)
