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


MASTERFILE=$FINALRESULTDIR/mobilemeasurement.xml
GPSFILE=$MASTERFILE
CSFILE=$MASTERFILE

#MASTERFILE=/dev/null
#GPSFILE=$FINALRESULTDIR/gps.xml
#CSFILE=$FINALRESULTDIR/channelstats.xml

echo -n "" > $GPSFILE
echo -n "" > $CSFILE
echo -n "" > $MASTERFILE

sleep 2;

while [ true ]; do
  echo "<mobilestats>" >> $MASTERFILE
  echo "" | $DIR/../../../../helper/host/bin/clickctrl.sh write localhost 7777 cst stats_xml >> $CSFILE
  echo "" | $DIR/../../../../helper/host/bin/clickctrl.sh write localhost 7777 gps gps_coord >> $GPSFILE
  echo "</mobilestats>" >> $MASTERFILE

  sleep 1
done

