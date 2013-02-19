#!/bin/bash

. $CONFIGFILE

(cd $RESULTDIR;ATH=yes fromdump.sh foobar103.ath0.raw.dump | grep -v tx | awk '{print $2" "$30" "$53" "$9" "$11" "$33" "$41" "$45" "$49" "$51" "$73}' | grep -v ":" | sed "s#(RX)#0#g" > ./regmon_dump_info_foobar103 )
(cd $RESULTDIR;regmon_hex2dec.sh regmon_data_foobar103)
(cd $RESULTDIR;ATH=yes fromdump.sh wgt55.ath0.raw.dump | grep -v tx | awk '{print $2" "$30" "$53" "$9" "$11" "$33" "$41" "$45" "$49" "$51" "$73}' | grep -v ":" | sed "s#(RX)#0#g" > ./regmon_dump_info_wgt55 )
(cd $RESULTDIR;regmon_hex2dec.sh regmon_data_wgt55)

exit 0

