#!/bin/sh

cat $1 | sed "s#,# #g" | awk '{print $1}' | sort -u > macs.dat.tmp
cat $1 | sed "s#,# #g" | awk '{print $17}' | sort -u >> macs.dat.tmp

cat macs.dat.tmp | awk '{print NR" "$1}' > macs.dat
rm -rf macs.dat.tmp
