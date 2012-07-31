#!/bin/sh

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
  "/")
     DIR=$dir
     ;;
  ".")
     DIR=$pwd/$dir
     ;;
   *)
     echo "Error while getting directory"
     exit -1
     ;;
esac

LIMIT=$LIMIT
i=$START

if [ "x$MODE" = "xSIMULATION" ]; then
  MODESTRING="Simulation"
fi

FAILED=0

while [ $i -le $LIMIT ]; do
  MEASUREMENTNUM=$RANDOM
  NUM=`printf "%03d\n" $i`
  WORKDIR=`ls -w 1 | awk '{print $1}' | grep "$NUM-"`
  NAME=`echo $WORKDIR | sed "s#$NUM-##g" | sed "s#_# #g"`
  DESCRIPTIONFILE=`(cd $WORKDIR;ls *.des | awk '{print $1}')`
  echo -n "Test $WORKDIR "

  if [ "x$MODE" = "xSIMULATION" ]; then
    (cd $WORKDIR; run_sim.sh ns $DESCRIPTIONFILE $MEASUREMENTNUM)
    RESULT=$?
  else
    if [ "x$MODE" = "xMEASUREMENT" ]; then
      (cd $WORKDIR; RUNMODE=REBOOT run_measurement.sh $DESCRIPTIONFILE $MEASUREMENTNUM )
      RESULT=$?
    else
      RESULT=1
    fi
  fi

  if [ $RESULT -ne 0 ]; then
    FAILED=1 #TODO: FAILED+=1
    if [ $RESULT -eq 1 ]; then
      echo "failed ! $MODESTRING failed !";
      SIM="Failed"
      EVO="Failed"
    else
      echo "failed ! Evaluation failed !";
      SIM="OK"
      EVO="Failed"
    fi
  else
    echo "Ok."
    SIM="OK"
    EVO="OK"

    if [ "x$VALGRIND" = "x1" ]; then
      LEAKBYTES=`(cd $WORKDIR/$MEASUREMENTNUM/; cat valgrind.log | grep -A 4 "LEAK SUMMARY" | grep "definitely lost" | awk '{print $4}' | sed "s#,##g" )`
      if [ $LEAKBYTES -eq 0 ]; then
        MEMORYLEAK=NO
      else
        MEMORYLEAK=YES
      fi
    fi

  fi

  if [ -f $WORKDIR/$MEASUREMENTNUM/time.stats ]; then
    TIMESTATS=`cat $WORKDIR/$MEASUREMENTNUM/time.stats`
  else
    TIMESTATS="00:00.00"
  fi

  (cd $WORKDIR; rm -rf $MEASUREMENTNUM/)


  i=`expr $i + 1`
done

exit $FAILED
