#!/bin/sh

echo -n "ID POS BAND"
echo -n " F_SENDER F_RECEIVER F_CHANNEL F_POWER F_HTMODE F_RATEINDEX F_BW F_HT F_SGI F_PACKET_SIZE"  #10
echo -n " M_SENDER M_RECEIVER M_CHANNEL M_POWER M_HTMODE M_RATEINDEX M_BW M_HT M_SGI M_PACKET_SIZE"  #10
echo -n " FS_NIC_BUSY FS_NIC_RX FS_NIC_TX FS_MAC_RX FS_RX_CRC_ERR" #5
echo -n " FR_NIC_BUSY FR_NIC_RX FR_NIC_TX FR_MAC_RX FR_RX_CRC_ERR"
echo -n " MS_NIC_BUSY MS_NIC_RX MS_NIC_TX MS_MAC_RX MS_RX_CRC_ERR"
echo -n " MR_NIC_BUSY MR_NIC_RX MR_NIC_TX MR_MAC_RX MR_RX_CRC_ERR"
echo -n " FS_MAC_TX_RATE MS_MAC_TX_RATE"
echo -n " FS_FR_RX_RATE MS_MR_RX_RATE FS_MR_RX_RATE MS_FR_RX_RATE"
echo -n " FS_FR_SNR MS_MR_SNR FS_MR_SNR MS_FR_SNR"
echo -n " FS_CPU FR_CPU MS_CPU MR_CPU"
echo ""


if [ "x$1" = "x" ]; then
  RESULTDIR="./"
else
  RESULTDIR="$1/"
fi

ID=0

PREFIXES=""

for d in `(cd $RESULTDIR; ls -d *_init_0*)`; do
  PREFIX=`(cd $RESULTDIR; echo "$d" | sed -e "s#_init*# #g" | awk '{print $1}')`
  PREFIXES="$PREFIXES $PREFIX"
done

for p in $PREFIXES; do

  for i in `(cd $RESULTDIR; ls -d $p\_init_*)`; do

    #echo "$i"

    if [ -e $RESULTDIR/$i/params ]; then
      . $RESULTDIR/$i/params

      echo -n "$ID 0 $MEASUREMENT $FIX_SENDER $FIX_RECEIVER $FIX_CHANNEL $POWER $FIX_HTMODE $FIX_RATEINDEX $FIX_BW $FIX_HT $FIX_SGI $FIX_PACKET_SIZE"
      echo -n " $FIX_SENDER $FIX_RECEIVER $FIX_CHANNEL $POWER $FIX_HTMODE $FIX_RATEINDEX $FIX_BW $FIX_HT $FIX_SGI $FIX_PACKET_SIZE"

      DEVICE=`cat $RESULTDIR/$i/nodes.mac | grep $FIX_SENDER | head -n 1 | awk '{print $2}'`
      SENDER_FILE="$RESULTDIR/$i/$FIX_SENDER.$DEVICE.log"
      RECEIVER_FILE="$RESULTDIR/$i/$FIX_RECEIVER.$DEVICE.log"

      for f in $SENDER_FILE $RECEIVER_FILE; do
        PHY_LINE=`cat $f | grep "phy hwbusy" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
        BUSY=`echo $PHY_LINE | awk '{print $3}'`
        RX=`echo $PHY_LINE | awk '{print $5}'`
        TX=`echo $PHY_LINE | awk '{print $7}'`

        MAC_LINE=`cat $f | grep "mac packets" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
        PACKETS=`echo $MAC_LINE | awk '{print $5}'`
        CRC_PACKETS=`echo $MAC_LINE | awk '{print $9}'`

        echo -n " $BUSY $RX $TX $PACKETS $CRC_PACKETS"

      done

      echo -n " 0 0 0 0 0 0 0 0 0 0"

      BYTE_BEGIN=`cat $SENDER_FILE | grep -A 1 "out_cnt.byte_count:" | head -n 2 | tail -n 1`
      BYTE_END=`cat $SENDER_FILE | grep -A 1 "out_cnt.byte_count:" | tail -n 1`

      PHY_PS=`expr $FIX_PACKET_SIZE + 32`
      DRV_PS=`expr $PHY_PS + 36`

      BITS_S=`expr \( $BYTE_END - $BYTE_BEGIN \) \* $DRV_PS / $PHY_PS`

      echo -n " $BITS_S 0"

      SENDER_MAC=`cat $RESULTDIR/$i/nodes.mac | grep $FIX_SENDER | head -n 1 | awk '{print $3}'`

      RXLINE=`cat $RECEIVER_FILE | grep "<nb addr" | grep "$SENDER_MAC" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
      RX_BYTE=`echo $RXLINE | awk '{print $15}'`
      RX_RATE=`expr $RX_BYTE \* 8`
      RX_SNR=`echo $RXLINE | awk '{print $5}'`

      echo -n " $RX_RATE 0 0 0 $RX_SNR 0 0 0"

      for f in $SENDER_FILE $RECEIVER_FILE; do
        CPULOAD=`cat $f | grep "cpu_usage" | sed -e "s#=# #g" -e 's#"##g' | awk '{print $3}' `
        echo -n " $CPULOAD"
      done

      echo " 0 0"
    fi
  done

#  for i in `ls `; do
#    if [ -e $i/params ]; then
#      #echo $i
#      . $i/params
#    
#      #<mac packets="713" rx_pkt="713" no_err_pkt="713" crc_err_pkt="0" phy_err_pkt="0" unknown_err_pkt="0" tx_pkt="0" rx_unicast_pkt="0" rx_retry_pkt="0" rx_bcast_pkt="713 " rx_bytes="2735068"
#      #tx_unicast_pkt="0" tx_retry_pkt="0" tx_bcast_pkt="0 " tx_bytes="0" zero_err_pkt="0" last_packet_time="1311197035.043253" no_src="1" />
#
#      MAC_INFO=`cat $i/wndr231.wlan1.log | grep "mac packet" | head -n 1`
#      RX_BYTES=`echo $MAC_INFO | sed "s#=# #g" | awk '{print $24}'`
#      echo "$FIX_HTMODE $FIX_RATEINDEX $FIX_BW $FIX_HT $FIX_SGI $FIX_PACKET_SIZE $RX_BYTES"
#    fi
#  done
done

