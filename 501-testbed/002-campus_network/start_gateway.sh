#!/bin/sh

/sbin/ifconfig eth0 mtu 1600
/sbin/ifconfig eth1 mtu 1470
/sbin/ifconfig tap0 mtu 1600

/testbedhome/testbed/helper/measurement/bin/run_click.sh gateway.click

exit 0

