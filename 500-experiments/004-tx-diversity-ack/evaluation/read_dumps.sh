#!/bin/sh

MES_FILE=`ls macclone.mes.*`

SENDER=`cat $MES_FILE | grep -v # | grep "sender_mac" | awk '{print $1}'`
SNIFFER=`cat $MES_FILE | grep -v # | grep "sniffer" | awk '{print $1}'`

for i in `ls *.dump`; do
    NODE=`echo $i | sed "s#.# #g" | awk '{print $1}'`
    DEVICE=`echo $i | sed "s#.# #g" | awk '{print $2}'`
    DUMPLOG="$NODE\.$DEVICE\.out"
    DATA_MAT="macclone_data.mat"
    ACK_MAT="macclone_ack.mat"

    if [ "x$NODE" != "x$SNIFFER" ]; then
      fromdump $i | grep 00-0A-0A-0A | sed "s#00-0A-0A-0A-0B-##g" | sed -e "s#fail##g" -e "s#Mb##g" -e  "s#unknown-#un known#g"  -e "s#+##g" -e "s#/# #g" -e "s#err ]#1#g" -e "s#]#0#g" > $DUMPLOG
    
      if [ "x$NODE" != "x$SENDER" ]; then
        cat $1 | grep "OKP" | awk '{print $5" "strtonum("0x"$10)" "strtonum("0x"$11)" "$19}' >> $MATA_MAT
    cat $1 | grep 00-0A-0A-0A | grep cntl | sed "s#err ]#1#g" | sed "s#]#0#g" | egrep "OKP|CRCe" | grep "ack" | sed -e "s#+##g" -e "s#/# #g" -e "s#Mb##g" -e "s#unknown-#un known#g" | awk '{print $5" "$6" "$16}' |
    grep "^1" > macclone_ack_1mbit.mat
    