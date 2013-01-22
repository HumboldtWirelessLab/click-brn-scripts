#!/bin/bash

PLACEMENTS="small random"

for p in $PLACEMENTS; do
  if [ "$p" = "random" ]; then
    XSTART=20 XLIM=30 YSTART=0 YLIM=30 ./gen_random_box_plm.sh 26 > placementfile.random
    PFILE=placementfile.random
  else
    PFILE=placementfile.plm.small
  fi

  PLACEMENTFILE=$PFILE SIM=1 sh ./run_backoff_test_multirate.sh

  FINALDIR=`date +"%Y%m%d"`
  FINALDIR=$FINALDIR"_"$p
  FINALDIRRES=$FINALDIR"-result"

  mkdir evaluation/$FINALDIRRES
  (cd evaluation; sh ./eval_all.sh ../; mv *.mat $FINALDIRRES; tar cvfj ../$FINALDIRRES.tar.bz2 $FINALDIRRES; rm -rf $FINALDIRRES)

  mkdir $FINALDIR
  ALLFILES=`ls -1 | grep -e "^[0-9][0-9]*$"`

  mv $ALLFILES $FINALDIR

  tar cvfj $FINALDIR.tar.bz2 $PFILE $FINALDIR
  rm -rf $FINALDIR

done
