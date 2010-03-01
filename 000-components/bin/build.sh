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

for i in $*; do
  FILEOUTNAME=`echo $i | sed -e "s#\.# #g" | awk '{print $1"_out."$2}'`
  cpp -I$DIR/../include $i | egrep -v "^#" > $FILEOUTNAME 
done

exit  0

