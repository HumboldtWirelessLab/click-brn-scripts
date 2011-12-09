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


for i in `(cd $1;ls -d *_ratepair_*)`; do 
#  echo $i;
  NODES=`cat $1/$i/nodes.mac | awk '{print $1}'`

  for n in $NODES; do
    if [ -e $1/$i/status/$n\_wificonfig.log ]; then
      CNT_ERRORS=`cat $1/$i/status/$n\_wificonfig.log | grep "failed" | wc -l`
      if [ $CNT_ERRORS -gt 0 ]; then
        echo "Error in $i"
      fi
    fi
  done
done

exit 0