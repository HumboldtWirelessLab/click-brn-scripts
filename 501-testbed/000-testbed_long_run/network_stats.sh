#!/bin/bash

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

case "$1" in
    start)
        echo "Start netstat"
	ssh -i ~/.ssh/id_dsa.matlab brn-suse093-7 "/testbedhome/testbed/hwl_stats/network_stats.sh start"
	#TODO: dispatcher CHANELLLOAD
	;;
    stop)
	echo "stop netstat"
	(ssh -i ~/.ssh/id_dsa.matlab brn-suse093-7 "/testbedhome/testbed/hwl_stats/network_stats.sh stop") &
	;;
    *)
	echo "Use $0 start|stop"
	;;
esac

exit 0
