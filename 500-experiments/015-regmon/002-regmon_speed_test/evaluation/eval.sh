#!/bin/bash

. $CONFIGFILE

DUMPS=`(cd $RESULTDIR; ls *.raw.dump)`

for d in $DUMPS; do
  if [ -f $RESULTDIR/$d ]; then
    (cd $RESULTDIR;ATH=yes fromdump.sh $d | grep -v tx | awk '{print $2" "$30" "$53" "$9" "$11" "$33" "$41" "$45" "$49" "$51" "$73}' | grep -v ":" | sed "s#(RX)#0#g" > ./regmon_dump_info )
  fi
done

if [ -f $RESULTDIR/regmon_data ]; then
  (cd $RESULTDIR;regmon_hex2dec.sh regmon_data)
fi

exit 0

                   4