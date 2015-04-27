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

if [ "x$1" = "x" ]; then
	DIRECTORIES=`find . -maxdepth 1 -type d | grep "\./[0-9]" | grep -v "-" | awk -F "/" '{print $2}' | sort -g`
elif [ "x$1" = "x../" ];then
	DIRECTORIES=`find "$ALLRESDIR" -maxdepth 1 -type d  | awk -F "/" '{print $NF}'  | grep -v "-" | grep -v "[a-z;A-Z]" | sort -g`
fi

DATE_CURRENT=`date +"%Y"-"%m"-"%d"_"%H":"%M":"%S"`
mkdir -p "$ALLRESDIR/$DATE_CURRENT"

for i in $DIRECTORIES; do
	mv "$ALLRESDIR/$i" "$ALLRESDIR/$DATE_CURRENT"
done

