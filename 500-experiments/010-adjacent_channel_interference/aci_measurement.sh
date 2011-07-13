#!/bin/sh

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
    "/")
	DIR=$dir
	;;
    ".")
	DIR=$pwd/$dir
	;;
    *)
	echo "Error while getting directory"
	exit -1
	;;
esac

. ./$1

POSITIONS=`seq 1 $POSITION_COUNT`

MODE=REBOOT
REPEATMODE=REBOOT
POSITIONREPEATMODE=REBOOT

#if [ "$p" != "none" ]; then
#  ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"
#fi

COUNT_RATES=`cat $1 | grep "#RATES" | awk '{print $2}' | sort -u | wc -l`
COUNT_SINGLE_LINKS=`cat $1 | grep "#SINGLELINK" | awk '{print $1}' | wc -l`
COUNT_LINK_PAIRS=`cat $1 | grep "#LINKPAIRS" | awk '{print $1}' | wc -l`
COUNT_RATE_PAIRS=`cat $1 | grep "#RATES" | wc -l`

MEASUREMENT_COUNT=0

for pow in $POWER; do
  for r in `seq 1 $COUNT_RATES`; do
    cat tmpl/mode.monitor | sed -e "s#VAR_CHANNEL#$CHANNEL_FIX#g" -e "s#VAR_POWER#$pow#g" > mode.monitor

    RATE=`cat $1 |  grep "#RATES" | awk '{print $2}' | sort -u | head -n $r | tail -n 1`
    HTMODE=`echo $RATE | sed "s#_# #g" | awk '{print $1}'`
    if [ "x$HTMODE" = "xHT40" ]; then
      echo "HTMODE=\"HT40+\"" >> mode.monitor
    fi

    BW=`echo $RATE | sed "s#_# #g" | awk '{print $1}' | sed -e "s#HT20#0#g" -e "s#HT40#1#g"`
    HT=`echo $RATE | sed "s#_# #g" | awk '{print $2}' | sed -e "s#NHT#false#g" -e "s#HT#true#g"`
    RATEINDEX=`echo $RATE | sed "s#_# #g" | awk '{print $3}'`
    SGI=`echo $RATE | sed "s#_# #g" | awk '{print $4}' | sed -e "s#0#false#g" -e "s#1#true#g"`

    cat tmpl/sender.click.tmpl | sed -e "s#PARAMS_RATEINDEX#$RATEINDEX#g" -e "s#PARAMS_MCS#$HT#g" -e "s#PARAMS_BANDWIDTH#$BW#g" -e "s#PARAMS_SGI#$SGI#g" -e "s#PARAMS_GF#$GF#g" > sender.click

    for l in `seq 1 $COUNT_SINGLE_LINKS`; do
      LINK=`cat $1 | grep "#SINGLELINK" | head -n $l | tail -n 1 | awk '{print $2" "$3}'`
      NODE_1=`echo $LINK | awk '{print $1}'`
      NODE_2=`echo $LINK | awk '{print $2}'`

      cat tmpl/throughput.mes.tmpl | sed -e "s#RECEIVER#$NODE_1#g" -e "s#SENDER#$NODE_2#g" -e "s#WLANDEVICE#$WLANDEVICE#g" > aci.mes

      FINALPATH=init_$MEASUREMENT_COUNT\_ht_$HT\_pow_$pow\_rate_$r\_channel_$CHANNEL_FIX\_link_$l\_monitor

      if [ ! -e $FINALPATH ]; then
        RUNMODE=$MODE run_measurement.sh aci.des $FINALPATH

        echo "POSITION=$p" > $FINALPATH/params
        echo "POWER=$pow" >> $FINALPATH/params
        echo "FIX_CHANNEL=$CHANNEL_FIX" >> $FINALPATH/params
        echo "FIX_HTMODE=$HTMODE" >> $FINALPATH/params
        echo "FIX_SENDER=$NODE_2" > $FINALPATH/params
        echo "FIX_RECEIVER=$NODE_1" >> $FINALPATH/params
        echo "FIX_RATEINDEX=$RATEINDEX" >> $FINALPATH/params
        echo "FIX_BW=$BW" >> $FINALPATH/params
        echo "FIX_HT=$HT" >> $FINALPATH/params
        echo "FIX_SGI=$SGI" >> $FINALPATH/params

        echo "MOBILE_CHANNEL=0" >> $FINALPATH/params
        echo "MOBILE_HTMODE=0" >> $FINALPATH/params
        echo "MOBILE_SENDER=0" > $FINALPATH/params
        echo "MOBILE_RECEIVER=0" >> $FINALPATH/params
        echo "MOBILE_RATEINDEX=0" >> $FINALPATH/params
        echo "MOBILE_BW=0" >> $FINALPATH/params

        echo "MOBILE_HT=0" >> $FINALPATH/params
        echo "MOBILE_SGI=0" >> $FINALPATH/params
      fi

      MEASUREMENT_COUNT=`expr $MEASUREMENT_COUNT + 1`

    done
  done
done

MEASUREMENT_COUNT=0
NUM=1

for p in $POSITIONS; do
  for pow in $POWER; do
    for c in $CHANNEL_MOBIL; do
      for r in `seq 1 $COUNT_RATE_PAIRS`; do

        cat tmpl/mode.monitor | sed -e "s#VAR_CHANNEL#$CHANNEL_FIX#g" -e "s#VAR_POWER#$pow#g" > mode_fix.monitor

        RATE_1=`cat $1 |  grep "#RATES" | awk '{print $2}' | sort -u | head -n $r | tail -n 1`
        HTMODE_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $1}'`
        if [ "x$HTMODE_1" = "xHT40" ]; then
          echo "HTMODE=\"HT40+\"" >> mode_fix.monitor
        fi

        BW_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $1}' | sed -e "s#HT20#0#g" -e "s#HT40#1#g"`
        HT_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $2}' | sed -e "s#NHT#false#g" -e "s#HT#true#g"`
        RATEINDEX_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $3}'`
        SGI_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $4}' | sed -e "s#0#false#g" -e "s#1#true#g"`

        cat tmpl/sender.click.tmpl | sed -e "s#PARAMS_RATEINDEX#$RATEINDEX_1#g" -e "s#PARAMS_MCS#$HT_1#g" -e "s#PARAMS_BANDWIDTH#$BW_1#g" -e "s#PARAMS_SGI#$SGI_1#g" -e "s#PARAMS_GF#$GF#g" > sender_fix.click

        cat tmpl/mode.monitor | sed -e "s#VAR_CHANNEL#$c#g" -e "s#VAR_POWER#$pow#g" > mode_mobile.monitor

        RATE_2=`cat $1 |  grep "#RATES" | awk '{print $3}' | sort -u | head -n $r | tail -n 1`
        HTMODE_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $1}'`
        if [ "x$HTMODE_2" = "xHT40" ]; then
          echo "HTMODE=\"HT40+\"" >> mode_mobile.monitor
        fi

        BW_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $1}' | sed -e "s#HT20#0#g" -e "s#HT40#1#g"`
        HT_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $2}' | sed -e "s#NHT#false#g" -e "s#HT#true#g"`
        RATEINDEX_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $3}'`
        SGI_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $4}' | sed -e "s#0#false#g" -e "s#1#true#g"`

        cat tmpl/sender.click.tmpl | sed -e "s#PARAMS_RATEINDEX#$RATEINDEX_2#g" -e "s#PARAMS_MCS#$HT_2#g" -e "s#PARAMS_BANDWIDTH#$BW_2#g" -e "s#PARAMS_SGI#$SGI_2#g" -e "s#PARAMS_GF#$GF#g" > sender_mobile.click

        for l in `seq 1 $COUNT_LINK_PAIRS`; do

          AC_LINK_PAIR=`cat $1 |  grep "#LINKPAIRS" | head -n $l | tail -n 1`
          SENDER_1=`echo $AC_LINK_PAIR | awk '{print $2}'`
          RECEIVER_1=`echo $AC_LINK_PAIR | awk '{print $3}'`
          SENDER_2=`echo $AC_LINK_PAIR | awk '{print $4}'`
          RECEIVER_2=`echo $AC_LINK_PAIR | awk '{print $5}'`

          cat tmpl/aci.mes.tmpl | sed -e "s#RECEIVER1#$RECEIVER_1#g" -e "s#SENDER1#$SENDER_1#g" -e "s#RECEIVER2#$RECEIVER_2#g" -e "s#SENDER2#$SENDER_2#g"-e "s#WLANDEVICE#$WLANDEVICE#g" > aci.mes

          for rep in `seq 1 $REPETITION`; do

            FINALPATH=$NUM\_pos_$p\_power_$pow\_channel_$c\_ratepair_$r\_link_$l\_rep_$rep\_monitor

            if [ ! -d $FINALPATH ]; then

              RUNMODE=$MODE run_measurement.sh aci.des $FINALPATH
              MODE=$REPEATMODE

              #(cd $FINALPATH; wget http://www2.informatik.hu-berlin.de/~sombrutz/pub/labs/webcam.jpeg )

              echo "POSITION=$p" > $FINALPATH/params
              echo "POWER=$pow" >> $FINALPATH/params
              echo "FIX_CHANNEL=$CHANNEL_FIX" >> $FINALPATH/params
              echo "FIX_HTMODE=$HTMODE_1" >> $FINALPATH/params
              echo "FIX_SENDER=$SENDER_1" > $FINALPATH/params
              echo "FIX_RECEIVER=$RECEIVER_1" >> $FINALPATH/params
              echo "FIX_RATEINDEX=$RATEINDEX_1" >> $FINALPATH/params
              echo "FIX_BW=$BW_1" >> $FINALPATH/params
              echo "FIX_HT=$HT_1" >> $FINALPATH/params
              echo "FIX_SGI=$SGI_1" >> $FINALPATH/params

              echo "MOBILE_CHANNEL=$c" >> $FINALPATH/params
              echo "MOBILE_HTMODE=$HTMODE_2" >> $FINALPATH/params
              echo "MOBILE_SENDER=$SENDER_2" > $FINALPATH/params
              echo "MOBILE_RECEIVER=$RECEIVER_2" >> $FINALPATH/params
              echo "MOBILE_RATEINDEX=$RATEINDEX_2" >> $FINALPATH/params
              echo "MOBILE_BW=$BW_2" >> $FINALPATH/params
              echo "MOBILE_HT=$HT_2" >> $FINALPATH/params
              echo "MOBILE_SGI=$SGI_2" >> $FINALPATH/params

            fi

            MEASUREMENT_COUNT=`expr $MEASUREMENT_COUNT + 1`

            #ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"

            NUM=`expr $NUM + 1`

          done
        done
      done
    done
  done

  MODE=$POSITIONREPEATMODE

#  ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/motor.sh $POSITION_STEP_DIRECTION $POSITION_STEP_LENGTH"
#  sleep 1;
#  ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 3"

done

exit 0
