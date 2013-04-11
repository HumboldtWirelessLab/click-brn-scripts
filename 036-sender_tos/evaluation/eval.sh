#!/bin/sh

if [ "x$1" = "x" ]; then
  ALLRESDIR=.
elif [ "x$1" = "x../" ];then
	ALLRESDIR=`dirname $PWD`
else
  ALLRESDIR=$1
fi

if [ "x$1" = "x../" ]; then
	DIR=$PWD
else
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
fi

#DIRNUM=1
INRANGE_MAT_TMP='inrange.mat.tmp'
INRANGE_MAT_2_TMP='inrange_2.mat.tmp'
INRANGE_CNT_MAT_TMP='inrange_cnt.mat.tmp'
INRANGE_BYTE_CNT_MAT_TMP='inrange_byte_cnt.mat.tmp'
INRANGE_MAT='inrange.mat'
INRANGE_OUTSORTED_MAT='inrange_outsorted.mat'
INRANGE_CNT_MAT='inrange_cnt.mat'
INRANGE_BYTE_CNT_MAT='inrange_byte_cnt.mat'
INRANGE_MAT_HEADER='inrange_mat.header'
INRANGE_CNT_MAT_HEADER='inrange_cnt_mat.header'
INRANGE_BYTE_CNT_MAT_HEADER='inrange_byte_cnt_mat.header'

> $INRANGE_MAT_TMP
> $INRANGE_CNT_MAT_TMP
> $INRANGE_BYTE_CNT_MAT_TMP


TEST_DIRNUM=0
ARRAY_MISSED_NUMBERS=""

if [ "x$1" = "x" ]; then
	DIRECTORIES=`find . -maxdepth 1 -type d | grep "\./[0-9]" | grep -v "-" | awk -F "/" '{print $2}' | sort -g`
elif [ "x$1" = "x../" ];then
	DIRECTORIES=`find "$ALLRESDIR" -maxdepth 1 -type d  | awk -F "/" '{print $NF}'  | grep -v "-" | grep -v "[a-z;A-Z]" | sort -g`

fi
for i in $DIRECTORIES; do
	DIRNUM=$i
	TEST_DIRNUM=`expr $TEST_DIRNUM + 1` 
	while [ "$TEST_DIRNUM" -ne "$DIRNUM" ]; do
		if [ "$ARRAY_MISSED_NUMBERS" = "" ]; then		
			ARRAY_MISSED_NUMBERS=$TEST_DIRNUM
		else
			ARRAY_MISSED_NUMBERS="$ARRAY_MISSED_NUMBERS,$TEST_DIRNUM"
		fi
		TEST_DIRNUM=`expr $TEST_DIRNUM + 1` 
	done
	if [ -f $ALLRESDIR/$DIRNUM/params ]; then
		if [ -f $ALLRESDIR/$DIRNUM/sender_and_receiver.des.real ]; then
		 	    $DIR/eval_helper.sh $ALLRESDIR/$DIRNUM $DIR $ALLRESDIR/$DIRNUM/sender_and_receiver.des.real $INRANGE_MAT_TMP $INRANGE_CNT_MAT_TMP $INRANGE_BYTE_CNT_MAT_TMP
    		else
      			 $DIR/eval_helper.sh $ALLRESDIR/$DIRNUM $DIR $ALLRESDIR/$DIRNUM/sender_and_receiver.des.ns2 $INRANGE_MAT_TMP $INRANGE_CNT_MAT_TMP $INRANGE_BYTE_CNT_MAT_TMP
    		fi
    		cat $ALLRESDIR/$DIRNUM/$INRANGE_MAT_TMP >> $INRANGE_MAT_TMP
    		cat $ALLRESDIR/$DIRNUM/$INRANGE_CNT_MAT_TMP >> $INRANGE_CNT_MAT_TMP
    		cat $ALLRESDIR/$DIRNUM/$INRANGE_BYTE_CNT_MAT_TMP >> $INRANGE_BYTE_CNT_MAT_TMP
  	fi
done

# Search global for all MAC-ADDRESSES 
# to convert all MAC-ADDRESSES in numbers
NODEMAC_SEDARG="" 
for i in $DIRECTORIES; do
	DIRNUM=$i
	while read line; do
      		NODENUM=`echo $line | awk '{print $4}'`
      		NODEMAC=`echo $line | awk '{print $3}'`
      		if [ "$NODENUM" != "" ]; then 
			if [ "$NODEMAC_SEDARG" = "" ]; then
				NODEMAC_SEDARG="s#$NODEMAC#$NODENUM#g"
			else
		      		NODEMAC_SEDARG="$NODEMAC_SEDARG;s#$NODEMAC#$NODENUM#g"
			fi
		#echo "$RESULTDIR:NODENUM=$NODENUM;NODEMAC=$NODEMAC"
      		fi		
	done < $ALLRESDIR/$DIRNUM/nodes.mac
done
#echo $NODEMAC_SEDARG

cat $INRANGE_MAT_TMP | sed "-e $NODEMAC_SEDARG"  > $INRANGE_MAT_2_TMP
cat $INRANGE_CNT_MAT_TMP  > $INRANGE_CNT_MAT
cat $INRANGE_BYTE_CNT_MAT_TMP  > $INRANGE_BYTE_CNT_MAT

# Search for MAC-ADRESSES, that are not assigned to a number
> $INRANGE_MAT
> $INRANGE_OUTSORTED_MAT
while read line; do
	ADDR_TEST=`echo $line | awk -F ',' '{print match($17,"-")}'`
	#echo "line = $line; $ADDR_TEST"
	if [ "$ADDR_TEST" -gt 0 ]; then
		echo "$line" >> $INRANGE_OUTSORTED_MAT
	else
		echo "$line" >> $INRANGE_MAT
	fi
done < $INRANGE_MAT_2_TMP


echo "NUM,NO_NODES,PACKETSIZE,BACKOFF,BACKOFF_MAX,SEED,RATE,TIME,NODE,ID,PHY_HWBUSY,PHY_HWRX,PHY_HWTX,RXPKT,CRCPKT,PHYPKT,ADDR,RSSI,STDRSSI,MINRSSI,MAXRSSI,PKTCNT,RXRETRIES,TXRETRIES,MAC_BUSY,MAC_RX,MAX_TX,MISSED_SEQ,CHANNEL,TARGET,CHANNELMODEL" > $INRANGE_MAT_HEADER
echo "NUM,NO_NODES,PACKETSIZE,BACKOFF,BACKOFF_MAX,SEED,RATE,PACKETCOUNT,TARGET,CHANNELMODEL" > $INRANGE_CNT_MAT_HEADER
echo "NUM,NO_NODES,PACKETSIZE,BACKOFF,BACKOFF_MAX,SEED,RATE,BYTECOUNT,TARGET,CHANNELMODEL" > $INRANGE_BYTE_CNT_MAT_HEADER

VAR_INRANGE_MAT_TMP=`cat $INRANGE_MAT_TMP | wc -l`
VAR_INRANGE_OUTSORTED_MAT=`cat $INRANGE_OUTSORTED_MAT | wc -l`
VAR_INRANGE_MAT=`cat $INRANGE_MAT | wc -l`
VAR_INRANGE_CNT_MAT_TMP=`cat $INRANGE_CNT_MAT_TMP | wc -l`
VAR_INRANGE_CNT_MAT=`cat $INRANGE_CNT_MAT | wc -l`
VAR_INRANGE_BYTE_CNT_MAT_TMP=`cat $INRANGE_BYTE_CNT_MAT_TMP | wc -l`
VAR_INRANGE_BYTE_CNT_MAT=`cat $INRANGE_BYTE_CNT_MAT | wc -l`

#echo "MISSING DIRECTORY-SEQUENZNUMBER = $ARRAY_MISSED_NUMBERS" 
#echo "Total lines in:" 
#echo "$INRANGE_MAT_TMP = $VAR_INRANGE_MAT_TMP	$INRANGE_MAT = $VAR_INRANGE_MAT	$INRANGE_OUTSORTED_MAT = $VAR_INRANGE_OUTSORTED_MAT"
#echo "$INRANGE_CNT_MAT_TMP =  $VAR_INRANGE_CNT_MAT_TMP	$INRANGE_CNT_MAT =  $VAR_INRANGE_CNT_MAT"
#echo "$INRANGE_BYTE_CNT_MAT_TMP = $VAR_INRANGE_BYTE_CNT_MAT_TMP	$INRANGE_BYTE_CNT_MAT = $VAR_INRANGE_BYTE_CNT_MAT"

rm -f $INRANGE_MAT_2_TMP 
rm -rf $ALLRESDIR/*.tmp

exit 0
