#!/bin/sh

export PATH=$PATH:/sbin:/usr/sbin/

mount -t debugfs none /sys/kernel/debug

#sysctl -w dev.wifi0.regmon_bufsize=100000
sysctl -w dev.wifi0.regmon_flags=0
sysctl -w dev.wifi0.cu_update_mode=16
sysctl -w dev.wifi0.regmon_interval=50

ls /sys/kernel/debug > /tmp/debugfs_$NODENAME.log

sysctl dev.wifi0.regmon_bufsize > /tmp/regmon_$NODENAME.log
sysctl dev.wifi0.regmon_flags >> /tmp/regmon_$NODENAME.log
sysctl dev.wifi0.cu_update_mode >> /tmp/regmon_$NODENAME.log
sysctl dev.wifi0.regmon_interval >> /tmp/regmon_$NODENAME.log


sleep 10

cat /sys/kernel/debug/regmon_data > /tmp/regmon_data_$NODENAME

sleep 10

mv /tmp/debugfs_$NODENAME.log /tmp/regmon_$NODENAME.log /tmp/regmon_data_$NODENAME $FINALRESULTDIR/
