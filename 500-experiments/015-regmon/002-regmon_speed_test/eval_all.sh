#!/bin/sh

for i in `ls | grep -e "^[0-9]*$"`; do
  cat $i/regmon_data.dec | awk -v NUM=$i '{print NUM" "$0}'
done