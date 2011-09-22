#!/bin/bash

cp simple.tcl.head simple.tcl

NO_NODES=`cat simple.tcl.head | grep -e "^set nodecount" | awk '{print $3}'`

cat $1 | head -n $NO_NODES | awk '{print " $node_("NR-1") set X_ "$2"\n $node_("NR-1") set Y_ "$3"\n $node_("NR-1") set Z_ "$4"\n $node_("NR-1") label $node_mac("NR-1").brn"}' >> simple.tcl

cat simple.tcl.bottom >> simple.tcl