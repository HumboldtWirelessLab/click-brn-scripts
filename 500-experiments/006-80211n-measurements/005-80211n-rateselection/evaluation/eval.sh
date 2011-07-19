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


DIRNUM=1

while [ -e $RESULTDIR/$DIRNUM/params ]; do


    NODES=`cat $RESULTDIR/$DIRNUM/nodes.mac | awk '{print $1}'`
    NODES_MAC=`cat $RESULTDIR/$DIRNUM/nodes.mac | awk '{print $3}'`

    . $RESULTDIR/$DIRNUM/params

    LINK_NUM=1

    for n in $NODES; do

      DEVICES=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$n " | awk '{print $2}'`
      MAC=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$n " | awk '{print $3}'`

      for d in $DEVICES; do

        if [ ! -f $RESULTDIR/$DIRNUM/$n.$d.raw.out ]; then

          if [ -f $RESULTDIR/$DIRNUM/$n.$d.raw.dump ]; then
            ( cd $RESULTDIR/$DIRNUM; $DIR/fromdump.sh $n.$d.raw.dump | grep -e ":   50 |" | grep "OKPack" | sed "s#Mb##g" | sed "s#/# #g" | awk '{print $5*10" "$6" "$7" "$8" "$9" "$10" "$11" "$16" "int((strtonum("0x"$25)-1)/60) }' | sed "s#+##g" > $n.$d.raw.out )
          else
            echo "Missing Dump for $n $d"
          fi
        fi

        for m in $NODES_MAC; do
          if [ $m != $MAC ]; then
            cat $RESULTDIR/$DIRNUM/$n.$d.raw.out | grep $m |  awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$9 }' >> $RESULTDIR/empirical_$PARAMS_POWER\_$LINK_NUM\.txt
            LINK_NUM=`expr $LINK_NUM + 1`
          fi
        done
      done
    done

    DIRNUM=`expr $DIRNUM + 1`

done

exit 0
