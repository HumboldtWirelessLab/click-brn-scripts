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

NODELIST=`cat $DIR/sender_and_receiver.mes | grep -v "#" | grep "seismo" | awk '{print $1}'`

case "$1" in
	"help")
		echo "Use $0 insmod"
		echo "Use NODELIST"
		;;
	"start")
		for node in $NODELIST; do
		    echo "$node"
		    ssh root@$node "/usr/sbin/wifiwatchdog.sh stop"
		done
		;;
	"stop")
		for node in $NODELIST; do
		    echo "$node"
		    echo "Don't enable wificheck"
		#    ssh root@$node "/etc/init.d/wifiwatchdog start"
		done
		;;
	*)
		$0 help
		;;
esac

exit 0		
