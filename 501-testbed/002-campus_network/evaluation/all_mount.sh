#!/bin/sh

for i in `cat nodes.outdoor | grep -v "#"`; do echo $i; ssh root@$i "ls /testbedhome" | grep testbed; done
