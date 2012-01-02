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
	scp $DIR/sync_gateway root@seismo184:/tmp
	ssh root@seismo184 "export PATH=/bin/:/sbin/:/usr/bin:/usr/sbin; SYNCPID=`pidof sync_gateway`;kill -9 $SYNCPID; killall sync_gateway";
	ssh root@seismo184 "(export PATH=/bin/:/sbin/:/usr/bin:/usr/sbin; cd /tmp/; /tmp/sync_gateway gw 60000 60001 192.168.3.184 10.5.70.12 &) &";
	SYNCPID=`pidof send_sync`
	echo "Stop old Sync"
	kill -9 $SYNCPID
        echo "Start Sync"
	$DIR/send_sync 60000 192.168.3.3 30 &
	;;
    stop)
	ssh root@seismo184 "export PATH=/bin/:/sbin/:/usr/bin:/usr/sbin; SYNCPID=`pidof sync_gateway`;kill -9 $SYNCPID; killall sync_gateway";
	SYNCPID=`pidof send_sync`
	echo "Stop Sync"
	kill -9 $SYNCPID
	;;
    *)
	echo "Use $0 start|stop"
	;;
esac

exit 0
