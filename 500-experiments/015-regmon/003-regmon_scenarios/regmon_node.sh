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

if [ -f $DIR/interval ]; then
  . $DIR/interval
else
  echo "File $DIR/interval doesn't exist"
fi

if [ "x$INTERVAL" = "x" ]; then
  INTERVAL=50
fi

if [ "x$NODENAME" = "x" ]; then
  NODENAME=`ifconfig eth0 | grep "addr:" | sed "s#:# #g" | awk '{print $3}'`
fi

export PATH=$PATH:/sbin:/usr/sbin/

mount -t debugfs none /sys/kernel/debug

sysctl -w dev.wifi0.regmon_bufsize=100000
sysctl -w dev.wifi0.regmon_flags=0
sysctl -w dev.wifi0.cu_update_mode=16
sysctl -w dev.wifi0.regmon_interval=$INTERVAL

ls /sys/kernel/debug > /tmp/debugfs_$NODENAME.log

sysctl dev.wifi0.regmon_bufsize > /tmp/regmon_$NODENAME.log
sysctl dev.wifi0.regmon_flags >> /tmp/regmon_$NODENAME.log
sysctl dev.wifi0.cu_update_mode >> /tmp/regmon_$NODENAME.log
sysctl dev.wifi0.regmon_interval >> /tmp/regmon_$NODENAME.log


sleep 10

cat /sys/kernel/debug/regmon_data > /tmp/regmon_data_$NODENAME

sleep 2

mv /tmp/debugfs_$NODENAME.log /tmp/regmon_$NODENAME.log /tmp/regmon_data_$NODENAME $FINALRESULTDIR/
