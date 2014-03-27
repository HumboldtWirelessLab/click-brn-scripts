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


#echo "Eval not valid"

#exit 0

. $CONFIGFILE

if [ -e $BRN_TOOLS_PATH/helper/evaluation/bin/functions.sh ]; then
  . $BRN_TOOLS_PATH/helper/evaluation/bin/functions.sh
fi

MATDIR=$BRN_TOOLS_PATH/helper/evaluation/scenarios/network_info

###############################################################################
# Get datafile
###############################################################################

echo "Get Datafile"

if [ ! -e $EVALUATIONSDIR ]; then
  mkdir -p $EVALUATIONSDIR
fi

if [ -f $RESULTDIR/measurement.xml ]; then
  DATAFILE=$RESULTDIR/measurement.xml
else
  if [ -f $EVALUATIONSDIR/measurement.xml ]; then
    DATAFILE=$EVALUATIONSDIR/measurement.xml
  else
    DATAFILE=$RESULTDIR/measurement.log
  fi
fi

###############################################################################
# create sed arg  for nodenamereplacement
###############################################################################
echo "Create sed arg"

FULLSED=""
FULLMACSED=""
while read line; do
  SRCN=`echo $line | awk '{print $1}'`
  SRCID=`echo $line | awk '{print $4}'`
  SRCMAC=`echo $line | awk '{print $3}'`

  FULLSED="$FULLSED -e s#^$SRCID\$#$SRCN#g"
  FULLMACSED="$FULLMACSED -e s#$SRCMAC#$SRCID#g"
done < $RESULTDIR/nodes.mac

###############################################################################
# set evaluation sub dir
###############################################################################
EVALUATIONSDIR="$EVALUATIONSDIR""/network_info"
if [ ! -e $EVALUATIONSDIR ]; then
  mkdir -p $EVALUATIONSDIR
fi

###############################################################################
# create linkmetric.all
###############################################################################
echo "Create linkmetric matrix"

THRESHOLD=400

if [ ! -f $EVALUATIONSDIR/linksmetric.all ]; then
  cat $DATAFILE | grep "link from" | grep -v 'metric="9999"' | sed 's#"# #g' | awk '{print $3" "$5" "$7}' | grep -v "=" | sort -u > $EVALUATIONSDIR/linksmetric.all
  cat $EVALUATIONSDIR/linksmetric.all | sed $FULLMACSED > $EVALUATIONSDIR/linksmetric.mat
fi

NODES=`cat $RESULTDIR/nodes.mac | awk '{print $3}'`

echo "Create linkgraph (Threshold: $THRESHOLD)"

if [ ! -f $EVALUATIONSDIR/graph.txt ]; then

  (cd $MATDIR; matwrapper "try,metric2graph('$EVALUATIONSDIR/linksmetric.mat','$EVALUATIONSDIR/graph.csv',$THRESHOLD),catch,exit(1),end,exit(0)" 1> /dev/null)
  cat $EVALUATIONSDIR/graph.csv | sed "s#,# #g" > $EVALUATIONSDIR/graph.txt

fi

###############################################################################
# create partition (etx linktable based)
###############################################################################

echo "Count part"

(cd $DIR; matwrapper "try,cnt_partitions('$EVALUATIONSDIR/graph.txt','$EVALUATIONSDIR/cnt_partitions.csv'),catch,exit(1),end,exit(0)" 1> /dev/null)

if [ $? -ne 0 ]; then
  echo "Ohh, matlab error."
fi


exit 0
