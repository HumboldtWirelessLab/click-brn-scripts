#!/bin/bash

. $CONFIGFILE

for i in foobar103 commander105 wgt55; do
 if [ -f $RESULTDIR/$i.ath0.raw.dump ]; then
  (cd $RESULTDIR;ATH=yes fromdump.sh $i.ath0.raw.dump | grep -v tx | awk '{print $2" "$30" "$53" "$9" "$11" "$33" "$41" "$45" "$49" "$51" "$73}' | grep -v ":" | sed "s#(RX)#0#g" > ./regmon_dump_info_$i )
 fi
 if [ -f $RESULTDIR/regmon_data_$i ]; then
  (cd $RESULTDIR;regmon_hex2dec.sh regmon_data_$i)
 fi
done

exit 0

