#!/bin/sh

RESULTDIR=$1

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR=$PWD
fi

ALGSEDARG="-e s#none#0#g -e s#default#1#g -e s#tworayground#2#g -e s#shadowing#3#g -e s#ricean#4#g -e s#nakagami#5#g"

echo -n "" > result_dist.dat
echo -n "" > result.dat
echo -n "" > result_index.dat

for d in `(cd $RESULTDIR; ls -l | grep "^d" | grep -v "evaluation" | awk '{print $NF}')`; do
  if [ -e $RESULTDIR/$d/params ]; then
    . $RESULTDIR/$d/config
    . $RESULTDIR/$d/1/result

    SIMID=`echo $d | sed -e "s#_# #g" | awk '{print $2}'`
    RADIOID=`echo $VAR_RADIO | sed $ALGSEDARG`

    echo "$SIMID $PACKETS" | sed $ALGSEDARG >> result_dist.dat

    cat $RESULTDIR/$d/1/result.dat | awk -v ID=$SIMID '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "ID}' | sed $ALGSEDARG | sort -u >> result_index.dat
    cat $RESULTDIR/$d/1/result.dat | awk -v ID=$SIMID '{print $9" "$10" "$11" "$12" "$13" "ID}' >> result.dat
  fi

done

exit 0

