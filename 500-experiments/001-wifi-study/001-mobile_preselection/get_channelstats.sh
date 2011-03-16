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

echo -n "" >  $FINALRESULTDIR/channelstats.xml
echo -n "" >  $FINALRESULTDIR/gps.xml

sleep 2;

while [ true ]; do
  echo "" | $DIR/../../../../helper/host/bin/clickctrl.sh write localhost 7777 cst stats_xml >> $FINALRESULTDIR/channelstats.xml
  echo "" | $DIR/../../../../helper/host/bin/clickctrl.sh write localhost 7777 gps gps_coord >> $FINALRESULTDIR/gps.xml
  sleep 1
done

