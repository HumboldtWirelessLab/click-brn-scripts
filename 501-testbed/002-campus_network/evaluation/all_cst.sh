#!/bin/sh

for i in `cat nodes.outdoor | grep -v "#"`; do clickctrl.sh read $i 7777 device_wifi/wifidevice/cst stats_xml; done
