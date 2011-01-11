#!/bin/sh

if [ "x$RESULTDIR" = "x" ]; then
  RESULTDIR="."
fi

MES_FILE=`(cd $RESULTDIR; ls macclone.mes.*)`

SENDER=`( cd $RESULTDIR; cat $MES_FILE | grep -v "#" | grep "sender_mac" | awk '{print $1}')`
SNIFFER=`( cd $RESULTDIR; cat $MES_FILE | grep -v "#" | grep "sniffer" | awk '{print $1}')`

NODENUM=1

DATA_MAT="macclone_data.mat"

echo "nodenumber mode(rx/tx/ack) rate rssi id id seq is_retry is_err retries" > layout.mat

echo -n "" > $DATA_MAT
echo -n "" > nodes.num

for i in `(cd $RESULTDIR;ls *.dump)`; do
    NODE=`echo $i | sed "s#\.# #g" | awk '{print $1}'`
    DEVICE=`echo $i | sed "s#\.# #g" | awk '{print $2}'`
    DUMPLOG="$NODE.$DEVICE.out"

    (cd $RESULTDIR; fromdump.sh $i | grep "00-0A-0A-0A" | sed "s#00-0A-0A-0A-0B-##g" | sed -e "s#fail##g" -e "s#Mb##g" -e "s#unknown-#un known#g" -e "s#+##g" -e "s#/# #g" -e "s#err ]#1#g" -e "s#]#0#g" -e "s#\[ retry#1#g" -e "s#\[#0#g"  ) > $DUMPLOG
    if [ "x$NODE" = "x$SNIFFER" ]; then
      echo "none"
    else
#nodenumber mode(rx/tx/ack) rate rssi id id seq is_retry is_err retries
      if [ "x$NODE" = "x$SENDER" ]; then
        cat $DUMPLOG | grep "TXF" | awk -v node=0 -v rx=0 '{print node" "rx" "$5" "$6" "strtonum("0x"$11)" "strtonum("0x"$12)" "$15" 0 0 "$20}' >> $DATA_MAT
        cat $DUMPLOG | grep "cntl" | egrep "OKP|CRCe" | grep "ack" | awk -v node=0 -v rx=2 '{print node" "rx" "$5" "$6" "strtonum("0x"$12)" "strtonum("0x"$12)" 0 0 "$1" 0"}' | sed -e "s#OKPacket:#0#g" -e "s#CRCerror:#1#g" >>  $DATA_MAT
        echo "0 $NODE" > nodes.num
      else
        cat $DUMPLOG | grep "OKP" | grep "data" | awk -v node=$NODENUM -v rx=1 '{print node" "rx" "$5" "$6" "strtonum("0x"$11)" "strtonum("0x"$12)" "$15" "$16" "$17" 0"}' >> $DATA_MAT
        echo "$NODENUM $NODE" > nodes.num
        NODENUM=`expr $NODENUM + 1`
      fi
    fi
done
