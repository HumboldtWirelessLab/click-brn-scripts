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

if [ "x$RESULTDIR" = "x" ]; then
  if [ "x$1" = "x" ]; then
    RESULTDIR=$DIR/../
  else
    RESULTDIR=$1
    SIGN=`echo $RESULTDIR | cut -b 1`

    case "$SIGN" in
      "/")
         ;;
       *)
         RESULTDIR="$PWD/$RESULTDIR"
         ;;
    esac
  fi
fi

echo -n "" > $RESULTDIR/check_results.txt

for f in `(cd $RESULTDIR/; ls allresult*.txt)`; do

  echo $f
  SRCNODES=`cat $RESULTDIR/$f | awk '{print $3}' | sort -u`
  DSTNODES=`cat $RESULTDIR/$f | awk '{print $4}' | sort -u`
  SIZES=`cat $RESULTDIR/$f | awk '{print $2}' | sort -u`
  RATES=`cat $RESULTDIR/$f | awk '{print $6}' | sort -u`

  NUM=`echo $f | sed "s#_# #g" | sed "s#\.# #g" | awk '{print $4}'`

  for sn in $SRCNODES; do
    for dn in $DSTNODES; do
      for s in $SIZES; do
        for r in $RATES; do
          if [ $sn -ne $dn ]; then
            NOP=`cat $RESULTDIR/$f | grep "$s $sn $dn 1 $r" | wc -l`
            if [ $NOP -gt 0 ]; then
              FIRST=`cat $RESULTDIR/$f | grep "$s $sn $dn 1 $r" | head -n 1 | awk '{ print $18}'`
              LAST=`cat $RESULTDIR/$f | grep "$s $sn $dn 1 $r" | tail -n 1 | awk '{ print $18}'`
              DIFF=`expr $LAST - $FIRST`
            else
              FIRST=0
              LAST=0
             DIFF=0
            fi
            echo "$sn $dn $s $r $NOP $FIRST $LAST $DIFF $NUM" >> $RESULTDIR/check_results.txt
          fi
        done
      done
    done
  done
done

exit 0
