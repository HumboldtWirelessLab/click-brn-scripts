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

export PATH=$PATH:/bin/:/sbin/:/usr/bin/:/usr/sbin/

case "$1" in
    start)
	WIRED=`ifconfig eth0 | grep "inet addr" | wc -l`
	
	if [ "x$WIRED" = "x0" ]; then
	    killall sync_gateway
	    sleep 1
	    SYNCPID=`pidof sync_gateway`
	    echo "Stop Sync"
	    kill -9 $SYNCPID
	    sleep 1

	    ADDRESS=`ifconfig ath1 | grep "inet addr" | sed "s#:# #g" | awk '{print $3}'`

	    ($DIR/sync_gateway fwd 60000 60001 $ADDRESS $ADDRESS > /dev/null &) &
	else
	    ADDRESS=`ifconfig eth0 | grep "inet addr" | sed "s#:# #g" | awk '{print $3}'`
	
	    if [ "x$ADDRESS" = "x192.168.3.184" ]; then
		($DIR/sync_gateway gw 60000 60001 192.168.3.184 $ADDRESS > /dev/null &) &
	    fi
	fi
	;;
    stop)
	SYNCPID=`pidof sync_gateway`
	echo "Stop Sync"
	kill -9 $SYNCPID
	;;
    *)
	echo "Use $0 start|stop"
	;;
esac

exit 0
