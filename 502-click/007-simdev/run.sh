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

click simdev.click > measurement.log 2>&1

if [ $? -eq 0 ]; then
  ./evaluation/eval.sh

  if [ $? -eq 0 ]; then
    xsltproc evaluation/simdev.xslt measurement.xml | sed "s#,# #g" > simdev.mat
  fi
fi

exit 0

