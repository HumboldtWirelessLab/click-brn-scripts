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
    echo "Use: \"RESULTDIR=dir $0\" or \"$0 dir\""
    exit 0
  else
    RESULTDIR=$1
  fi
fi

SIGN=`echo $RESULTDIR | cut -b 1`

case "$SIGN" in
  "/")
	;;
  "~")
	;;
    *)
        RESULTDIR="$PWD/$RESULTDIR"
        ;;
esac

NUM=1


echo -n "" > $RESULTDIR/channelload.mat
echo -n "" > $RESULTDIR/neighbourstats.mat

while [ -e $RESULTDIR/$NUM ]; do

  if [ ! -e $RESULTDIR/$NUM/channelload.mat ]; then
    $DIR/eval.sh $RESULTDIR/$NUM
  fi

  if [ ! -e $RESULTDIR/$NUM/neighbourstats.mat ]; then
    $DIR/eval.sh $RESULTDIR/$NUM
  fi

  $DIR/eval.sh $RESULTDIR/$NUM

  cat $RESULTDIR/$NUM/channelload.mat >> $RESULTDIR/channelload.mat
  cat $RESULTDIR/$NUM/neighbourstats.mat | grep -v "FF-FF-FF-FF-FF-FF" >> $RESULTDIR/neighbourstats.mat

  let NUM=NUM+1

done

cat $RESULTDIR/neighbourstats.mat | sed "s#,# #g" | awk '{print $7}' | sort -u | awk '{print NR" "$1}' > $RESULTDIR/neighbournodes.txt

NODEMAC_SEDARG="-e s#foobar#barfoo#g"

NODECOUNT=`cat $RESULTDIR/1/nodes.mac | wc -l`

while read line; do
  NODEID=`echo $line | awk '{print $1}'`
  NODEMAC=`echo $line | awk '{print $2}'`
  NODEID=`expr $NODEID + $NODECOUNT`
  NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODEID#g"
done < $RESULTDIR/neighbournodes.txt

cat $RESULTDIR/neighbourstats.mat | sed $NODEMAC_SEDARG > $RESULTDIR/neighbourstats.mat.fin
mv $RESULTDIR/neighbourstats.mat.fin $RESULTDIR/neighbourstats.mat

	