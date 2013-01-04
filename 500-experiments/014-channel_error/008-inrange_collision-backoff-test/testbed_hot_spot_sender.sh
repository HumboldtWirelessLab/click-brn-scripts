#!/bin/sh
for i in `cat nodes | grep -v "#"`; do clickctrl.sh read $i 7777 wifidevice/cst stats; done | human_readable.sh 1/nodes.mac | less 
#for i in `10.5.59.162`; do clickctrl.sh read $i 7777 wifidevice/cst stats; done | human_readable.sh 1/nodes.mac | less 
#for i in `cat node_receiver | grep -v "#"`; do clickctrl.sh read $i 7777 wifidevice/cst stats; done | human_readable.sh 1/nodes.mac  

#i=10.5.59.162
#clickctrl.sh read $i 7777 wifidevice/cst stats; 
#| human_readable.sh 1/nodes.mac 

