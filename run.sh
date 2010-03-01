#!/bin/sh


for i in `ls .`; do
  if [ -f $i/FILES ]; then
      (cd $i; ns simple.tcl > output.log 2>&1 )
  fi
done
      
exit 0
