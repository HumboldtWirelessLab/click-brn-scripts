#!/bin/sh

//ps::BRN2PacketSource(SIZE PARAMS_PACKETSIZE, INTERVAL 10, MAXSEQ 500000, BURST PARAMS_BURST, ACTIVE false)
//rate::SetTXRates( RATE0 PARAMS_RATEINDEX, TRIES0 PARAMS_RETRIES, MCS0 PARAMS_MCS, BW0 PARAMS_BANDWIDTH, SGI0 PARAMS_SGI, GF0 PARAMS_GF, FEC0 0, SP0 true, STBC0 false, DEBUG false )

CHANNEL="6 153"
BANDWIDTH="0 1"
RATEINDEX="0 3 7 8 11 15"
SGI="false true"
GF="false true"
PACKET_SIZE="1500 2200 3800"


CURRENT_RUNMODE=REBOOT

MEASUREMENT_NUM=1

for p_c in $CHANNEL; do

 for p_bw in $BANDWIDTH; do

  for p_ri in $RATEINDEX; do

   for p_sg in $SGI; do

    for p_gf in $GF; do 

     for p_ps in $PACKET_SIZE; do

       if [ ! -e $MEASUREMENT_NUM ]; then

           baserate_index=`expr $p_ri % 8`
           baserate=`cat ratetab | grep baserate`
           p_burst=

           SEDARG=" -e s#PARAMS_RATEINDEX#$p_ri#g -e s#PARAMS_BANDWIDTH#$p_bw#g -e s#PARAMS_SGI#$p_sg#g -e s#PARAMS_GF#$p_gf#g -e s#PARAMS_PACKETSIZE#$p_ps#g -e s#PARAMS_BURST#$p_burst#g "

           if [ $p_c -lt 15 ]; then
             cat monitor.802.tmpl |  sed -e "s#PARAMS_CHANNEL#6#g" -e "s#PARAMS_POWER#27#g" > monitor.802
	     cat sender_and_receiver.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan0#g" > sender_and_receiver.mes
	   else
             cat monitor.802.tmpl |  sed -e "s#PARAMS_CHANNEL#153#g" -e "s#PARAMS_POWER#30#g" > monitor.802
	     cat sender_and_receiver.mes.tmpl | sed -e "s#PARAMS_DEVICE#wlan1#g" > sender_and_receiver.mes
           fi

           if [ $p_bw -eq 1 ]; then
             echo "HTMODE=\"HT40-\"" >> monitor.802
           fi

	   cat sender.click.tmpl | sed $SEDARG > sender.click

	   RUNMODE=$CURRENT_RUNMODE run_measurement.sh sender_and_receiver.des $MEASUREMENT_NUM

	   echo "PARAMS_RATEINDEX=$p_ri" > $MEASUREMENT_NUM/params
	   echo "PARAMS_BANDWIDTH=$p_bw" >> $MEASUREMENT_NUM/params
	   echo "PARAMS_SGI=$p_sg" >> $MEASUREMENT_NUM/params
	   echo "PARAMS_GF=$p_gf" >> $MEASUREMENT_NUM/params
	   echo "PARAMS_CHANNEL=$p_c" >> $MEASUREMENT_NUM/params
	   echo "PARAMS_PACKETSIZEL=$p_ps" >> $MEASUREMENT_NUM/params

	   MEASUREMENT_NUM=`expr $MEASUREMENT_NUM + 1`
	
	   CURRENT_RUNMODE=CLICK

	   if [ -f finish ]; then
	     exit 0;
	   fi

        fi
      done
     done
    done
   done
  done

  CURRENT_RUNMODE=REBOOT

 done
done


