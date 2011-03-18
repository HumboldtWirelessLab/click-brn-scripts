#!/bin/sh

cat $1 | sed "s#,# #g" | awk '{print $1}' | grep -v "00-00-00-00-00-00" | sort -u > macs.dat.tmp
cat $1 | sed "s#,# #g" | awk '{print $23}' | grep -v "00-00-00-00-00-00" | sort -u >> macs.dat.tmp

echo "0 00-00-00-00-00-00" > macs.dat
cat macs.dat.tmp | awk '{print NR" "$1}' >> macs.dat
rm -rf macs.dat.tmp
