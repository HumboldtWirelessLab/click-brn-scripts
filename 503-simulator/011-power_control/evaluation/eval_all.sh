#!/bin/sh

RESULTDIR=$1

ALGSEDARG="-e s#tworayground#0#g -e s#shadowing#1#g "

#echo -n "" > result_dist.dat

for d in `(cd $RESULTDIR; ls -l | grep "^d" | grep -v "evaluation" | awk '{print $NF}')`; do
  if [ -e $RESULTDIR/$d/params ]; then
    . $RESULTDIR/$d/config
    . $RESULTDIR/$d/1/result

    SIMID=`echo $d | sed -e "s#_# #g" | awk '{print $2}'`
    RADIOID=`echo $VAR_RADIO | sed $ALGSEDARG`

    echo "$SIMID $RADIOID $VAR_RXRANGE $PACKETS"

  fi

done

exit 0

