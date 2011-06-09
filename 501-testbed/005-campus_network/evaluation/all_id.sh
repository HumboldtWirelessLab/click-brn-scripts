#!/bin/sh

for i in `cat nodes.outdoor | grep -v "#"`; do echo $i; clickctrl.sh read $i 7777 id info; done
