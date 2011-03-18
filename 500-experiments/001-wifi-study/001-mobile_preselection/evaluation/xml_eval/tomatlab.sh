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

if [ "x$1" = "x" ]; then
  FILENAME=mobilemeasurement.xml
else
  FILENAME=$1
fi

xsltproc $DIR/mobilemeasurement.xslt mobilemeasurement.xml | sed "s#,# #g" > mobilemeasurement.mat.tmp

sh $DIR/mac2id.sh mobilemeasurement.mat.tmp

cat mobilemeasurement.mat.tmp | $DIR/mac2id_replace.sh > mobilemeasurement.mat

rm -rf mobilemeasurement.mat.tmp mobilegps.mat.tmp  mobilemeasurement.xml mobilegps.xml macs.dat
