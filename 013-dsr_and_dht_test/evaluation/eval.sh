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
							       

STABLE_SUCC=`cat $RESULTDIR/measurement.log | grep "<successor" | sed "s#\"# #g" | awk '{print $7}' | sort -u`
NO_NODES=`cat $RESULTDIR/nodes.mac | awk '{print $1}' | sort -u | wc -l`


echo -n "Modes: $STABLE_SUCC."

if [ "x$STABLE_SUCC" = "xtrue" ]; then
  echo " OK !"
else
  echo " Failed! Successor not stable."
fi
  
RESULT=`$DIR/check_dht.sh $RESULTDIR/measurement.log | grep "ALL_NODES"`
NO_DHT_NODES=`echo $RESULT | awk '{print $2}'`
NO_ERRORS=`echo $RESULT | awk '{print $4}'`
  
echo "Have $NO_NODES node(s) overall and $NO_DHT_NODES dht node(s). DHT routing has $NO_ERRORS error(s)."
  
if [ $NO_ERRORS -gt 0 ] || [ $NO_NODES -ne $NO_DHT_NODES ] || [ "x$STABLE_SUCC" = "xtrue" ]; then
 echo "DHT routing failed"
 exit 2
fi

exit 0
