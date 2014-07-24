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

echo -n "" > backoffusage.mat
echo -n "" > bovalues.mat

for i in `ls -d ../[0-9]*`; do

  (cd $i; sh ./eval_again.sh)

  . $i/params

  CHANNEL_MODEL=`echo $CHANNEL_MODEL | sed -e "s#real#0#g" -e "s#shadowing#1#g" -e "s#tworayground#2#g"`
  PKT_TARGET=`echo $PKT_TARGET | sed -e "s#USE_BROADCAST#0#g" -e "s#USE_UNICAST#1#g"`
  TARGET=`echo $TARGET | sed -e "s#USE_BROADCAST#0#g" -e "s#USE_UNICAST#1#g"`

  #NUM=1
  #NO_NODES=2
  #PACKETSIZE=1500
  #TOS2QUEUEMAPPER_STRATEGY=0
  #SEED=1
  #RATE=125
  #TARGET=USE_BROADCAST
  #CHANNEL_MODEL=shadowing11b

  PARAMS="$NUM $NO_NODES $PACKETSIZE $TOS2QUEUEMAPPER_STRATEGY $RATE $TARGET $CHANNEL_MODEL"

  cat $i/evaluation/backoffusage.mat | awk -v params="$PARAMS" '{print params" "$0}' >> backoffusage.mat
  cat $i/evaluation/bovalues.mat | awk -v params="$PARAMS" '{print params" "$0}' >> bovalues.mat

done

(cd $DIR;  matwrapper.sh "try,backoff_eval,catch,exit(1),end,exit(0)" 1> /dev/null)

exit 0
