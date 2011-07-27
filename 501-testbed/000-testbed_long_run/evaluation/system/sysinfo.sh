#!/bin/sh

for i in `cat $1 | grep -v "#"`; do
  clickctrl.sh read $i 7777 sys_info systeminfo
done
