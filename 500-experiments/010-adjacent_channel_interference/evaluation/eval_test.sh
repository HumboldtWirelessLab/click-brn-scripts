#!/bin/sh

echo "ID POS FIX_SENDER FIX_RECEIVER FIX_HTMODE FIX_RATEINDEX FIX_BW FIX_HT FIX_SGI FIX_PACKET_SIZE "

for i in `ls`; do
  if [ -e $i/params ]; then
    #echo $i
    . $i/params
    
    #<mac packets="713" rx_pkt="713" no_err_pkt="713" crc_err_pkt="0" phy_err_pkt="0" unknown_err_pkt="0" tx_pkt="0" rx_unicast_pkt="0" rx_retry_pkt="0" rx_bcast_pkt="713 " rx_bytes="2735068"
    #tx_unicast_pkt="0" tx_retry_pkt="0" tx_bcast_pkt="0 " tx_bytes="0" zero_err_pkt="0" last_packet_time="1311197035.043253" no_src="1" />

    MAC_INFO=`cat $i/wndr231.wlan1.log | grep "mac packet" | head -n 1`
    RX_BYTES=`echo $MAC_INFO | sed "s#=# #g" | awk '{print $24}'`
    echo "$FIX_HTMODE $FIX_RATEINDEX $FIX_BW $FIX_HT $FIX_SGI $FIX_PACKET_SIZE $RX_BYTES"
  fi
done


