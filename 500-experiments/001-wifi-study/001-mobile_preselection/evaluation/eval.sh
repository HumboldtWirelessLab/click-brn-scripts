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
  echo "Use $0 dir"
  exit 0
fi

(cd $1; CONFIGFILE=./receiver.dis.real ATH=yes RESULTDIR=. /testbedhome/testbed/helper/evaluation/scenarios/basic/eval.sh)
(cd $1/evaluation; /testbedhome/testbed/helper/evaluation/scenarios/matlab/eval.sh)

echo "Results in $1/evaluation"
