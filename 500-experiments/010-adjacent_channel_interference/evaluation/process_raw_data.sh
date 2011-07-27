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

      FIX_PACKET_SIZE=`expr $FIX_PACKET_SIZE + 32`

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

      PHY_PS=$FIX_PACKET_SIZE
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

      ID=`expr $ID + 1`
    fi
  done

  for i in `(cd $RESULTDIR; ls -d $p*_ratepair_*)`; do

    if [ -e $RESULTDIR/$i/params ]; then
      #echo $i
      . $RESULTDIR/$i/params

      FIX_PACKET_SIZE=`expr $FIX_PACKET_SIZE + 32`
      MOBILE_PACKET_SIZE=`expr $MOBILE_PACKET_SIZE + 32`

      echo -n "$ID $POSITION $MEASUREMENT $FIX_SENDER $FIX_RECEIVER $FIX_CHANNEL $POWER $FIX_HTMODE $FIX_RATEINDEX $FIX_BW $FIX_HT $FIX_SGI $FIX_PACKET_SIZE"
      echo -n " $MOBILE_SENDER $MOBILE_RECEIVER $MOBILE_CHANNEL $POWER $MOBILE_HTMODE $MOBILE_RATEINDEX $MOBILE_BW $MOBILE_HT $MOBILE_SGI $MOBILE_PACKET_SIZE"

      DEVICE=`cat $RESULTDIR/$i/nodes.mac | grep $FIX_SENDER | head -n 1 | awk '{print $2}'`
      FIX_SENDER_FILE="$RESULTDIR/$i/$FIX_SENDER.$DEVICE.log"
      FIX_RECEIVER_FILE="$RESULTDIR/$i/$FIX_RECEIVER.$DEVICE.log"
      MOB_SENDER_FILE="$RESULTDIR/$i/$MOBILE_SENDER.$DEVICE.log"
      MOB_RECEIVER_FILE="$RESULTDIR/$i/$MOBILE_RECEIVER.$DEVICE.log"

      for f in $FIX_SENDER_FILE $FIX_RECEIVER_FILE $MOB_SENDER_FILE $MOB_RECEIVER_FILE; do
        PHY_LINE=`cat $f | grep "phy hwbusy" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
        BUSY=`echo $PHY_LINE | awk '{print $3}'`
        RX=`echo $PHY_LINE | awk '{print $5}'`
        TX=`echo $PHY_LINE | awk '{print $7}'`

        MAC_LINE=`cat $f | grep "mac packets" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
        PACKETS=`echo $MAC_LINE | awk '{print $5}'`
        CRC_PACKETS=`echo $MAC_LINE | awk '{print $9}'`

        echo -n " $BUSY $RX $TX $PACKETS $CRC_PACKETS"

      done

      for f in $FIX_SENDER_FILE $MOB_SENDER_FILE; do
        BYTE_BEGIN=`cat $f | grep -A 1 "out_cnt.byte_count:" | head -n 2 | tail -n 1`
        BYTE_END=`cat $f | grep -A 1 "out_cnt.byte_count:" | tail -n 1`

        if [ $f = $FIX_SENDER_FILE ]; then
          PHY_PS=$FIX_PACKET_SIZE
        else
           PHY_PS=$MOBILE_PACKET_SIZE
        fi

        DRV_PS=`expr $PHY_PS + 36`

        BITS_S=`expr \( $BYTE_END - $BYTE_BEGIN \) \* $DRV_PS / $PHY_PS`

        echo -n " $BITS_S"
      done

      FIX_SENDER_MAC=`cat $RESULTDIR/$i/nodes.mac | grep $FIX_SENDER | head -n 1 | awk '{print $3}'`
      MOB_SENDER_MAC=`cat $RESULTDIR/$i/nodes.mac | grep $MOBILE_SENDER | head -n 1 | awk '{print $3}'`

      RXLINE=`cat $FIX_RECEIVER_FILE | grep "<nb addr" | grep "$FIX_SENDER_MAC" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
      if [ "x$RXLINE" = "x" ]; then
        FF_RX_RATE=0
        FF_RX_SNR=0
      else
        FF_RX_BYTE=`echo $RXLINE | awk '{print $15}'`

        FF_RX_RATE=`expr $FF_RX_BYTE \* 8`
        FF_RX_SNR=`echo $RXLINE | awk '{print $5}'`
      fi

      RXLINE=`cat $MOB_RECEIVER_FILE | grep "<nb addr" | grep "$MOB_SENDER_MAC" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
      if [ "x$RXLINE" = "x" ]; then
        MM_RX_RATE=0
        MM_RX_SNR=0
      else
        MM_RX_BYTE=`echo $RXLINE | awk '{print $15}'`

        MM_RX_RATE=`expr $MM_RX_BYTE \* 8`
        MM_RX_SNR=`echo $RXLINE | awk '{print $5}'`
      fi

      RXLINE=`cat $MOB_RECEIVER_FILE | grep "<nb addr" | grep "$FIX_SENDER_MAC" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
      if [ "x$RXLINE" = "x" ]; then
        FM_RX_RATE=0
        FM_RX_SNR=0
      else
        FM_RX_BYTE=`echo $RXLINE | awk '{print $15}'`

        FM_RX_RATE=`expr $FM_RX_BYTE \* 8`
        FM_RX_SNR=`echo $RXLINE | awk '{print $5}'`
      fi

      RXLINE=`cat $FIX_RECEIVER_FILE | grep "<nb addr" | grep "$MOB_SENDER_MAC" | head -n 3 | tail -n 1 | sed -e "s#=# #g" -e 's#"##g'`
      if [ "x$RXLINE" = "x" ]; then
        MF_RX_RATE=0
        MF_RX_SNR=0
      else
        MF_RX_BYTE=`echo $RXLINE | awk '{print $15}'`

        MF_RX_RATE=`expr $MF_RX_BYTE \* 8`
        MF_RX_SNR=`echo $RXLINE | awk '{print $5}'`
      fi

      echo -n " $FF_RX_RATE $MM_RX_RATE $FM_RX_RATE $MF_RX_RATE $FF_RX_SNR $MM_RX_SNR $FM_RX_SNR $MF_RX_SNR"

      for f in $FIX_SENDER_FILE $FIX_RECEIVER_FILE $MOB_SENDER_FILE $MOB_RECEIVER_FILE; do
        CPULOAD=`cat $f | grep "cpu_usage" | sed -e "s#=# #g" -e 's#"##g' | awk '{print $3}' `
        echo -n " $CPULOAD"
      done

      echo ""

      ID=`expr $ID + 1`

    fi
  done
done

