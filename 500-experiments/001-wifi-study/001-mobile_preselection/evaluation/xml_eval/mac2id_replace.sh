#!/bin/bash

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

if [ -f macs.dat ]; then
  while read line; do
    NODEID=`echo $line | awk '{print $1}'`
    NODEMAC=`echo $line | awk '{print $2}'`
    NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODEID#g"
  done < macs.dat
fi

sed $NODEMAC_SEDARG
