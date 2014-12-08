#!/bin/sh

RESULTDIR=$1

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR=$PWD
fi

ALGSEDARG="-e s#tworayground#0#g -e s#shadowing#1#g -e s#ricean#2#g -e s#nakagami#3#g"

echo -n "" > result_dist.dat
echo -n "" > result.dat

for d in `(cd $RESULTDIR; ls -l | grep "^d" | grep -v "evaluation" | awk '{print $NF}')`; do
  if [ -e $RESULTDIR/$d/params ]; then
    . $RESULTDIR/$d/config
    . $RESULTDIR/$d/1/result

    SIMID=`echo $d | sed -e "s#_# #g" | awk '{print $2}'`
    RADIOID=`echo $VAR_RADIO | sed $ALGSEDARG`

    echo "$SIMID $RADIOID $VAR_RXRANGE $PACKETS" >> result_dist.dat

    cat $RESULTDIR/$d/1/result.dat | sed $ALGSEDARG >> result.dat
  fi

done

exit 0

