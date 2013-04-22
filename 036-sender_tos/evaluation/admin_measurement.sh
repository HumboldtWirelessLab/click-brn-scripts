#!/bin/sh

if [ "x$1" = "x" ]; then #current directory
  ALLRESDIR=.
elif [ "x$1" = "x../" ];then #upper directory(one step)
	ALLRESDIR=`dirname $PWD`
else
  ALLRESDIR=$1 #Var "$1" reference for the directory
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

if [ "x$1" = "x" ]; then
	DIRECTORIES=`find . -maxdepth 1 -type d | grep "\./[0-9]" | grep -v "-" | awk -F "/" '{print $2}' | sort -g`
elif [ "x$1" = "x../" ];then
	DIRECTORIES=`find "$ALLRESDIR" -maxdepth 1 -type d  | awk -F "/" '{print $NF}'  | grep -v "-" | grep -v "[a-z;A-Z]" | sort -g`
else 
	DIRECTORIES=`find "$ALLRESDIR" -maxdepth 1 -type d  | awk -F "/" '{print $NF}'  | grep -v "-" | grep -v "[a-z;A-Z]" | sort -g`
fi

echo $ALLRESDIR
echo $DIRECTORIES
FILE_DEBUG=debug.txt
FILE_NODES_MAC=nodes.mac
FILE_EXPERIMENT_PARAMETER=params
> $FILE_DEBUG 
NODETABLE="sender_and_receiver.mes.real"
for i in $DIRECTORIES; do
	DIR_CURRENT="$ALLRESDIR/$i"
	NODETABLE=`echo "$DIR_CURRENT/$NODETABLE" | awk -F "/" '{print $NF}'` 
	LIST_RECEIVER=`cat "$DIR_CURRENT/$NODETABLE" | grep "receiver.click" | awk '{print $1}'`
	LIST_SENDER=`cat "$DIR_CURRENT/$NODETABLE" | grep "sender.click" | awk '{print $1}'`
	EXPERIMENT_PARAMS=`cat "$DIR_CURRENT/$FILE_EXPERIMENT_PARAMETER"`
	echo "DIR_CURRENT:=$DIR_CURRENT" >> $FILE_DEBUG
	echo -e  "\t<ParameterUSED>" >> $FILE_DEBUG
	echo -e "\t $EXPERIMENT_PARAMS" >> $FILE_DEBUG
	echo -e "\t</ParameterUSED>" >> $FILE_DEBUG
	len=`echo $LIST_RECEIVER | wc -w`
	echo -e "\t Receiver-List (Total Number:=$len)" >> $FILE_DEBUG
	for j in $LIST_RECEIVER; do
		RECEIVER_PROPERTIES=`cat "$DIR_CURRENT/$FILE_NODES_MAC" | grep "$j"`
		echo -e "\t\t $RECEIVER_PROPERTIES"  >> $FILE_DEBUG
	done
	len=`echo $LIST_SENDER | wc -w`
	echo -e "\t Sender-List (Total Number:=$len)" >> $FILE_DEBUG
	for j in $LIST_SENDER; do
		SENDER_PROPERTIES=`cat "$DIR_CURRENT/$FILE_NODES_MAC" | grep "$j"`
		echo -e "\t\t $SENDER_PROPERTIES"  >> $FILE_DEBUG
	done
done
