#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage: $0 <measurement.log>"
	exit -1
fi

LOGPATH="$1" 
if [ ! -f "$LOGPATH" ]; then
	echo "$LOGPATH is not a file."
	exit -1
fi

XMLPATH="$LOGPATH.xml"
echo "<evaluation>" > $XMLPATH
for i in $LOGPATH; do
  	echo "<channelloadmeasurement num='$NUM' no_nodes='$NO_NODES' packetsize='$PACKETSIZE' backoff='$BACKOFF' backoff_max='$BACKOFF_MAX' seed='$SEED' rate='$RATE' ptktarget='$PKT_TARGET' channelmodel='$CHANNEL_MODEL' >" >> $XMLPATH
  	cat $i | egrep "[:space:]*<" >> $XMLPATH
  	echo "</channelloadmeasurement>" >> $XMLPATH
done
echo "</evaluation>" >> $XMLPATH