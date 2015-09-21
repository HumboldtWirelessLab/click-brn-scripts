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

. $CONFIGFILE

DATAFILE=$EVALUATIONSDIR/measurement.xml

xsltproc $DIR/nblist.xslt $DATAFILE | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac > $EVALUATIONSDIR/nblist.csv
sed "s#,# #g" $EVALUATIONSDIR/nblist.csv > $EVALUATIONSDIR/nblist.mat

NBLISTSIZE=`cat $EVALUATIONSDIR/nblist.mat | wc -l`

echo "$NBLISTSIZE entries found."

if [ $NBLISTSIZE -gt 0 ]; then
  exit 0
else
  exit 2
fi
