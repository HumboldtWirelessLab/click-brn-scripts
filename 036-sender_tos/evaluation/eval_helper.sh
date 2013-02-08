#!/bin/sh
# ------------ Test Input -------------------------------
if [ "$#" -eq 6 ] ; then
     RESULTDIR_HELPER="$1"
     DIR="$2"
     CONFIGFILE="$3"
     INRANGE_MAT_TMP=$4 #inrange.mat.tmp
     INRANGE_CNT_MAT_TMP=$5 #inrange_cnt.mat.tmp
     INRANGE_BYTE_CNT_MAT_TMP=$6 #inrange_byte_cnt.mat.tmp
else
    echo " "
    echo "Usage: Please do the following comand:"
    echo "./eval_helper.sh [Result-Directory to evaluate the measurement] [Directory of the XML-FILE:"channelload.xslt" ] [CONFIGFILE] [INRANGE_MAT_TMP] [INRANGE_CNT_MAT_TMP] [INRANGE_BYTE_CNT_MAT_TMP]"
    echo " "
    echo "Notation:"
    echo "[Config-File] has to be [click-des-File]"
    exit 1
fi


. $CONFIGFILE	# is getting from another script
RESULTDIR=$RESULTDIR_HELPER
. $RESULTDIR/$PARAMSFILE # see CONFIGFILE 


# Some Helper-Variables 
RECEIVER_XML=receiver.xml
RECEIVER_INFO_MAT=receiver_info.mat.tmp
RECEIVER_CNT_MAT=receiver_cnt.mat.tmp
RECEIVER_BYTE_CNT_MAT=receiver_byte_cnt.mat.tmp

NODES_MAC=nodes.mac
XML_FILE=channelload.xslt
RECEIVER_TR=receiver.tr
MEASUREMENT_LOG=measurement.log

# PARSING "$RESULTDIR/$PARAMSFILE" is starting here
CHANNEL_MODEL=`echo $CHANNEL_MODEL | sed -e "s#real#0#g" -e "s#shadowing11b#1#g" -e "s#tworayground01b#2#g"`
PKT_TARGET=`echo $TARGET | sed -e "s#USE_BROADCAST#0#g" -e "s#USE_UNICAST#1#g"`
if [ "x$CHANNEL_MODEL" = "x" ]; then
  CHANNEL_MODEL="-1"
fi

if [ "x$PKT_TARGET" = "x" ]; then
  PKT_TARGET="-1"
fi
# if  Simulation has to be evaluated
if [ "x$MODE" = "xsim" ]; then

  if [ "x$SIM" = "xns2" ] && [ -f $RESULTDIR/$RECEIVER_TR ]; then
    SEND_PACKETS=`cat $RESULTDIR/$RECEIVER_TR | grep -e "^s " | wc -l`
    RETRIES_PACKETS=`cat $RESULTDIR/$RECEIVER_TR | grep -e "MAC  RET " | wc -l`
    COLL_PACKETS=`cat $RESULTDIR/$RECEIVER_TR | grep -e "MAC  COL " | wc -l`
    RECV_PACKETS=`cat $RESULTDIR/$RECEIVER_TR | grep -e "^r " | wc -l`

    RECV_APP_PACKETS=`cat $RESULTDIR/$MEASUREMENT_LOG | grep -A 1 cnt.count | tail -n 1`
    RECV_APP_BYTES=`cat $RESULTDIR/$MEASUREMENT_LOG | grep -A 1 cnt.byte_count | tail -n 1`

    SEND_ALL=`expr $SEND_PACKETS + $RETRIES_PACKETS`
  fi
fi

# Parse Nodetable, which is specified in $CONFIGFILE
NODETABLE=`echo $NODETABLE | awk -F "/" '{print $NF}'` 
RECEIVER=`cat $RESULTDIR/$NODETABLE | grep "receiver.click" | awk '{print $1}'`

if [ "x$MODE" = "xsim" ]; then
  RECEIVERLOG=`cat $RESULTDIR/$NODETABLE | grep "receiver.click" | awk '{print $8}'`
else 
  RECEIVERLOG=`cat $RESULTDIR/$MEASUREMENT_LOG | grep "receiver.click" | awk -F "receiver.click." '{print $2".log"}'` #Parse measurement.log for receiver 
fi

echo "<evaluation>" > $RESULTDIR/$RECEIVER_XML
for i in $RECEIVERLOG; do
  		echo "<channelloadmeasurement num='$NUM' no_nodes='$NO_NODES' packetsize='$PACKETSIZE' backoff='$BACKOFF' backoff_max='$BACKOFF_MAX' seed='$SEED' rate='$RATE' ptktarget='$PKT_TARGET' channelmodel='$CHANNEL_MODEL' >" >> $RESULTDIR/$RECEIVER_XML
  		cat $RESULTDIR/$i | egrep "[:space:]*<" >> $RESULTDIR/$RECEIVER_XML
  		echo "</channelloadmeasurement>" >> $RESULTDIR/$RECEIVER_XML
done
echo "</evaluation>" >> $RESULTDIR/$RECEIVER_XML

xsltproc $DIR/$XML_FILE $RESULTDIR/$RECEIVER_XML > $RESULTDIR/$RECEIVER_INFO_MAT
while read line; do
      NODENUM=`echo $line | awk '{print $4}'`
      NODEMAC=`echo $line | awk '{print $3}'`
      if [ "$NODENUM" != "" ]; then 
      	NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUM#g"
      fi		
done < $RESULTDIR/$NODES_MAC
cat $RESULTDIR/$RECEIVER_INFO_MAT | sed $NODEMAC_SEDARG | sed "s#00-1B-B1#06-1B-B1#g" > $RESULTDIR/$INRANGE_MAT_TMP

> $RESULTDIR/$RECEIVER_CNT_MAT
> $RESULTDIR/$RECEIVER_BYTE_CNT_MAT
for i in $RECEIVERLOG; do
	helper_cnt=`cat $RESULTDIR/$i | grep  -A 1 "cnt.count" | grep -v "cnt.count"`
	helper_cnt_byte=`cat $RESULTDIR/$i | grep  -A 1 "cnt.byte_count" | grep -v "cnt.byte_count"`
	for j in $helper_cnt; do
		if [ "$j" != "--" ] ; then
			echo "$NUM,$NO_NODES,$PACKETSIZE,$BACKOFF,$BACKOFF_MAX,$SEED,$RATE,$j,$PKT_TARGET,$CHANNEL_MODEL" >> $RESULTDIR/$RECEIVER_CNT_MAT
		fi
	done
	for j in $helper_cnt_byte; do
		if [ "$j" != "--" ] ; then
    			echo "$NUM,$NO_NODES,$PACKETSIZE,$BACKOFF,$BACKOFF_MAX,$SEED,$RATE,$j,$PKT_TARGET,$CHANNEL_MODEL" >> $RESULTDIR/$RECEIVER_BYTE_CNT_MAT
		fi
	done
done

cat $RESULTDIR/$RECEIVER_CNT_MAT | sed $NODEMAC_SEDARG > $RESULTDIR/$INRANGE_CNT_MAT_TMP
cat $RESULTDIR/$RECEIVER_BYTE_CNT_MAT | sed $NODEMAC_SEDARG > $RESULTDIR/$INRANGE_BYTE_CNT_MAT_TMP

rm -f  $RESULTDIR/$RECEIVER_XML
exit 0
