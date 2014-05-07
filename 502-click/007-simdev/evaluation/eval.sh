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

echo "<simdev>" > measurement.xml
cat measurement.log | grep -e "^[[:space:]]*<" >> measurement.xml
echo "</simdev>" >> measurement.xml

exit 0

