#!/bin/sh

#rate::SetTXRates( RATE0 PARAMS_RATEINDEX, TRIES0 1, MCS0 true, BW0 PARAMS_BANDWIDTH, SGI0 PARAMS_SGI, GF0 PARAMS_GF, FEC0 PARAMS_FEC, SP0 PARAMS_SHORTPREAMBLE, STBC0 PARAMS_STBC, DEBUG false )

CHANNEL="6 153"
RATEINDEX="1 7 8 15"
BANDWIDTH="0 1"
SGI="false true"
GF="false true"
FEC="0 1"
SHORTPREAMBLE="false true"
STBC="false true"

CURRENT_RUNMODE=REBOOT

MEASUREMENT_NUM=1

for p_c in $CHANNEL; do 
 
 for p_bw in $BANDWIDTH; do
 
  for p_ri in $RATEINDEX; do
 
   for p_sg in $SGI; do
 
    for p_gf in $GF; do 

     for p_fec in $FEC; do

      for p_sp in $SHORTPREAMBLE; do  

       for p_stbc in $STBC; do

        if [ "x$p_stbc" = "false"] || [ $p_ri -lt 8 ]; then

         SEDARG=" -e s#PARAMS_RATEINDEX#$p_ri#g -e s#PARAMS_BANDWIDTH#$p_bw#g -e s#PARAMS_SGI#$p_sg#g -e s#PARAMS_GF#$p_gf#g -e s#PARAMS_FEC#$p_fec#g -e s#PARAMS_SHORTPREAMBLE#$p_sp#g -e s#PARAMS_STBC#$p_stbc#g "

         if [ $CHANNEL -lt 15 ]; then
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
	 echo "PARAMS_FEC=$p_fec" >> $MEASUREMENT_NUM/params
	 echo "PARAMS_SHORTPREAMBLE=$p_sp" >> $MEASUREMENT_NUM/params
	 echo "PARAMS_STBC=$p_stbc" >> $MEASUREMENT_NUM/params
	 echo "PARAMS_CHANNEL=$p_c" >> $MEASUREMENT_NUM/params
	 
	 MEASUREMENT_NUM=`expr $MEASUREMENT_NUM + 1`
	
	 CURRENT_RUNMODE=CLICK

       done	

      done
    
     done

    done

   done
   
  done

  CURRENT_RUNMODE=REBOOT

 done
 
done
