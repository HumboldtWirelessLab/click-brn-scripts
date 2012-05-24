#!/bin/sh

PACKETSIZE="68 2168"
INTERVAL="25"
#PACKETCOUNT="10000"
PACKETCOUNT="5000"
RATES="g1 n1 n2 n3 n4 n5 n6 n7 n8"

#CHANNEL="6"
CHANNEL="11"
#CHANNEL="44"
#CHANNEL="161"

REPEAT=1

CURRENT_RUNMODE=REBOOT

REBOOT_COUNTER=0

MEASUREMENT_NUM=1

rm -f ./finish

for p_repeat in `seq $REPEAT`; do

 for p_c in $CHANNEL; do

  for p_node in `cat nodes.all | grep -v "#"`; do

    while [ ! -e $MEASUREMENT_NUM ]; do

      cat nodes.all | grep -v "$p_node" | grep -v "#" > nodes

      RUNTIME=`expr $INTERVAL \* $PACKETCOUNT`
      RUNTIME=`expr $RUNTIME / 800`
      RUNTIME=`expr $RUNTIME + 240`

      cat sender_and_receiver.des.tmpl | sed -e "s#PARAMS_TIME#$RUNTIME#g" > sender_and_receiver.des

      cp  probe_sender.click.tmpl probe_sender.click

      if [ $p_c -lt 15 ]; then
        POWER=27
        INTERPOWER=17
        cat monitor.802.tmpl | sed -e "s#PARAMS_CHANNEL#$p_c#g" -e "s#PARAMS_POWER#$POWER#g" > monitor.802
        cat monitor.805.nocca.tmpl | sed -e "s#PARAMS_CHANNEL#$p_c#g" -e "s#PARAMS_POWER#$INTERPOWER#g" > monitor.805.nocca
        cat sender_and_receiver.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan0#g" -e "s#SENDERNODE#$p_node#g" > sender_and_receiver.mes
        WLANDEV=wlan0
	echo "Idle() -> ee_b1;" >> probe_sender.click
      else
        if [ $p_c -gt 100 ]; then
          POWER=30
          INTERPOWER=17
        else
          POWER=30
          INTERPOWER=17
        fi
        cat monitor.802.tmpl | sed -e "s#PARAMS_CHANNEL#$p_c#g" -e "s#PARAMS_POWER#$POWER#g" > monitor.802
        cat monitor.805.nocca.tmpl | sed -e "s#PARAMS_CHANNEL#$p_c#g" -e "s#PARAMS_POWER#$INTERPOWER#g" > monitor.805.nocca
        cat sender_and_receiver.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan1#g" -e "s#SENDERNODE#$p_node#g" > sender_and_receiver.mes
        WLANDEV=wlan1
	echo "Idle() -> ee_b1;" >> probe_sender.click
      fi

      PSID=0

      for p_s in $PACKETSIZE; do
        for p_rate in $RATES; do
      
          if [ $p_c -gt 15 ] && [ "$p_rate" = "b1" ]; then
	    echo "//disable 1MBIT" >> probe_sender.click
	  else
            echo "ps_$PSID::BRN2PacketSource(SIZE $p_s, INTERVAL $INTERVAL, MAXSEQ 500000, BURST 1, PACKETCOUNT $PACKETCOUNT, ACTIVE false) -> ee_$p_rate;" >> probe_sender.click
	    PSID=`expr $PSID + 1`
          fi

        done
      done

     echo -n "Script(" >> probe_sender.click
     echo "wait 120"  >> probe_sender.click

     PSID=0

     for p_s in $PACKETSIZE; do
       for p_rate in $RATES; do

          if [ $p_c -gt 15 ] && [ "$p_rate" = "b1" ]; then
            echo "trash" > /dev/null
	  else
            echo ",write ps_$PSID.active true" >> probe_sender.click
	    PSID=`expr $PSID + 1`
          fi

        done
      done

      echo ");" >> probe_sender.click

      #TESTONLY=0 
      RUNMODE=$CURRENT_RUNMODE run_measurement.sh sender_and_receiver.des $MEASUREMENT_NUM
      REBOOT_COUNTER=`expr $REBOOT_COUNTER + 1`

      echo "PARAMS_CHANNEL=$p_c" > $MEASUREMENT_NUM/params
      echo "PARAMS_REPEAT=$p_repeat" >> $MEASUREMENT_NUM/params
      echo "PARAMS_INTERVAL=$INTERVAL" >> $MEASUREMENT_NUM/params
      echo "PARAMS_SENDER=$p_node" >> $MEASUREMENT_NUM/params
      echo "PARAMS_PACKETCOUNT=$PACKETCOUNT" >> $MEASUREMENT_NUM/params


      rm -f monitor.802 probe_sender.click sender_and_receiver.des sender_and_receiver.mes nodes monitor.805.nocca
#      rm -f monitor.802 sender_and_receiver.des sender_and_receiver.mes nodes

      CURRENT_RUNMODE=CLICK

      TXPACKETS=`(cd $MEASUREMENT_NUM; fromdump.sh $p_node.$WLANDEV.raw.dump | grep "TXFeed" | wc -l )`

      if [ $TXPACKETS -lt 89984 ]; then
        DATE=`date`
        RAND=$RANDOM
        echo "$DATE : measurement $MEASUREMENT_NUM faild. $TXPACKETS instead of 90000. mv $MEASUREMENT_NUM to $MEASUREMENT_NUM.$RAND for more info. Restart measurement with REBOOT" >> measurement_error.log
        mv $MEASUREMENT_NUM $MEASUREMENT_NUM.$RAND
        CURRENT_RUNMODE=REBOOT
      fi

      if [ -f finish ]; then
        exit 0;
      fi

    done

    MEASUREMENT_NUM=`expr $MEASUREMENT_NUM + 1`

   done
  CURRENT_RUNMODE=REBOOT
 done
done
