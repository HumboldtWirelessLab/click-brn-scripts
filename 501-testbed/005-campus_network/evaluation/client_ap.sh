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


function get_handler() {
echo "<map_info>"
clickctrl.sh read 192.168.4.164 7777 rev_arp_tap table
clickctrl.sh read 192.168.4.164 7777 lease_tab leases
echo "</map_info>"

}

GREPARG="$1,"
#echo $GREPARG
get_handler | xsltproc $DIR/client_ap.xslt - | grep "$GREPARG" | sed "s#,# #g" | awk '{print $3}' | tail -n 1
