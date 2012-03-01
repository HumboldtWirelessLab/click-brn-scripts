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

embrace_xml() {
  echo "<$NAME>"
  cat <&0
  echo "</$NAME>"
}


to_id() {
if [ -f $RESULTDIR/nodes.mac ]; then
  while read line; do
    NODEID=`echo $line | awk '{print $4}'`
    NODEMAC=`echo $line | awk '{print $3}'`
    NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODEID#g"
  done < $RESULTDIR/nodes.mac

  tr '[:upper:]' '[:lower:]' | sed $NODEMAC_SEDARG
else
  cat <&0
fi
}
	      
#cat $EVALUATIONSDIR/measurement.xml | embrace_xml > $EVALUATIONSDIR/flow_stats.xml
cat $EVALUATIONSDIR/measurement.xml | embrace_xml | xsltproc $DIR/dsr_performance.xslt - | to_id | sed -e "s#rx#0#g" -e "s#tx#1#g" -e "s#,# #g" > $EVALUATIONSDIR/flow_stats.mat
