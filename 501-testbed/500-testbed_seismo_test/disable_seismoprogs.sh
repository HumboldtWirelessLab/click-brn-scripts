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

NODELIST=`cat $DIR/nodes.seismo | grep -v "#" | awk '{print $1}'`

case "$1" in
	"help")
		echo "Use $0 start|stop"
		;;
	"start")
		for node in $NODELIST; do
		    echo "$node"
		    ssh root@$node "/etc/init.d/cron stop"
		done
		;;
	"stop")
		for node in $NODELIST; do
		    echo "$node"
		    ssh root@$node "/etc/init.d/cron start"
		done
		;;
	"test")
		for node in $NODELIST; do
		    echo "$node"
		    ssh root@$node "ps"
		done
		;;
	*)
		$0 help
		;;
esac

exit 0		
