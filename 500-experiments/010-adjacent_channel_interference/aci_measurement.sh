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


do_finish() {
  rm -rf aci.mes measurment_counter.* mode.monitor mode_fix.monitor mode_mobile.monitor sender.click sender_fix.click sender_mobile.click finish

  exit 0
}


INIT_MEASUREMENT=1

#TEST=1

SCRIPTS="$@"

. ./$1

POSITIONS=`seq 1 $POSITION_COUNT`

#SENDER_TMPL=sender.click.tmpl
SENDER_TMPL=sender_fast.click.tmpl

MODE=REBOOT
LINKREPEATMODE=REBOOT
SCRIPTREPEATMODE=REBOOT
RATEREPEATMODE=DRIVER
PACKETREPEATMODE=CLICK
POSITIONREPEATMODE=REBOOT
REPEATMODE=CLICK

ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 3"

if [ $INIT_MEASUREMENT -eq 1 ]; then

for params in $SCRIPTS; do

  . ./$params

  if [ "xUSE_TESTRATE" = "x1" ]; then
    COUNT_RATES=`cat $params | grep "#TESTRATE" | awk '{print $2}' | sort -u | wc -l`
  else
    COUNT_RATES=`cat $params | grep "#RATES" | awk '{print $2}' | sort -u | wc -l`
  fi

  COUNT_SINGLE_LINKS=`cat $params | grep "#SINGLELINK" | awk '{print $1}' | wc -l`
  COUNT_LINK_PAIRS=`cat $params | grep "#LINKPAIRS" | awk '{print $1}' | wc -l`
  COUNT_RATE_PAIRS=`cat $params | grep "#RATES" | wc -l`

  MEASUREMENT_COUNT=0

  for l in `seq 1 $COUNT_SINGLE_LINKS`; do
    LINK=`cat $params | grep "#SINGLELINK" | head -n $l | tail -n 1 | awk '{print $2" "$3}'`
    NODE_1=`echo $LINK | awk '{print $1}'`
    NODE_2=`echo $LINK | awk '{print $2}'`

    cat tmpl/throughput.mes.tmpl | sed -e "s#RECEIVER#$NODE_1#g" -e "s#SENDER#$NODE_2#g" -e "s#WLANDEVICE#$WLANDEVICE#g" > aci.mes

    for pow in $POWER; do
      for r in `seq 1 $COUNT_RATES`; do
        cat tmpl/mode.monitor | sed -e "s#VAR_CHANNEL#$CHANNEL_FIX#g" -e "s#VAR_POWER#$pow#g" > mode.monitor

        if [ "xUSE_TESTRATE" = "x1" ]; then
          RATE=`cat $params |  grep "#TESTRATE" | awk '{print $2}' | sort -u | head -n $r | tail -n 1`
        else
          RATE=`cat $params |  grep "#RATES" | awk '{print $2}' | sort -u | head -n $r | tail -n 1`
        fi

        HTMODE=`echo $RATE | sed "s#_# #g" | awk '{print $1}'`
        if [ "x$HTMODE" = "xHT40" ]; then
          echo "HTMODE=\"HT40+\"" >> mode.monitor
        fi

        BW=`echo $RATE | sed "s#_# #g" | awk '{print $1}' | sed -e "s#HT20#0#g" -e "s#HT40#1#g"`
        HT=`echo $RATE | sed "s#_# #g" | awk '{print $2}' | sed -e "s#NHT#false#g" -e "s#HT#true#g"`
        RATEINDEX=`echo $RATE | sed "s#_# #g" | awk '{print $3}'`
        SGI=`echo $RATE | sed "s#_# #g" | awk '{print $4}' | sed -e "s#0#false#g" -e "s#1#true#g"`


        if [ "$HT" = "true" ]; then
          PACKET_SIZE_LIST="$HTPACKETSIZE $NONHTPACKETSIZE"
        else
          PACKET_SIZE_LIST=$NONHTPACKETSIZE
        fi

        for PACKET_SIZE in $PACKET_SIZE_LIST; do
          cat tmpl/$SENDER_TMPL | sed -e "s#PARAMS_RATEINDEX#$RATEINDEX#g" -e "s#PARAMS_MCS#$HT#g" -e "s#PARAMS_BANDWIDTH#$BW#g" -e "s#PARAMS_SGI#$SGI#g" -e "s#PARAMS_GF#$GF#g" -e "s#PACKET_SIZE#$PACKET_SIZE#g" > sender.click

          FINALPATH=`echo "$MEASUREMENT_PREFIX\_init_$MEASUREMENT_COUNT\_ht_$HT\_pow_$pow\_rate_$r\_channel_$CHANNEL_FIX\_link_$l\_monitor" | sed -e "s#\\\\\##g"`

          if [ ! -e $FINALPATH ]; then
            if [ "x$MODE" = "x" ]; then
              MODE=REBOOT
              echo "MODEERROR: $PACKET_SIZE $pow $r $l" >> modeerror
            fi

            if [ "x$TEST" = "x1" ]; then
              TESTONLY=1 RUNMODE=$MODE run_measurement.sh aci.des $FINALPATH
            else
              RUNMODE=$MODE run_measurement.sh aci.des $FINALPATH
            fi

            if [ ! -e $FINALPATH ]; then
              mkdir $FINALPATH
            fi

            echo "MEASUREMENT=$MEASUREMENT_PREFIX" > $FINALPATH/params
            echo "POSITION=1" >> $FINALPATH/params
            echo "POWER=$pow" >> $FINALPATH/params
            echo "FIX_CHANNEL=$CHANNEL_FIX" >> $FINALPATH/params
            echo "FIX_HTMODE=$HTMODE" >> $FINALPATH/params
            echo "FIX_SENDER=$NODE_2" >> $FINALPATH/params
            echo "FIX_RECEIVER=$NODE_1" >> $FINALPATH/params
            echo "FIX_RATEINDEX=$RATEINDEX" >> $FINALPATH/params
            echo "FIX_BW=$BW" >> $FINALPATH/params
            echo "FIX_HT=$HT" >> $FINALPATH/params
            echo "FIX_SGI=$SGI" >> $FINALPATH/params
            echo "FIX_PACKET_SIZE=$PACKET_SIZE" >> $FINALPATH/params

            echo "MOBILE_CHANNEL=0" >> $FINALPATH/params
            echo "MOBILE_HTMODE=0" >> $FINALPATH/params
            echo "MOBILE_SENDER=0" >> $FINALPATH/params
            echo "MOBILE_RECEIVER=0" >> $FINALPATH/params
            echo "MOBILE_RATEINDEX=0" >> $FINALPATH/params
            echo "MOBILE_BW=0" >> $FINALPATH/params
            echo "MOBILE_HT=0" >> $FINALPATH/params
            echo "MOBILE_SGI=0" >> $FINALPATH/params
            echo "MOBILE_PACKET_SIZE=$PACKET_SIZE" >> $FINALPATH/params

            cp ./$params $FINALPATH/

            MODE=$PACKETREPEATMODE

            ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"
            sleep 1

          fi

          if [ -f finish ]; then
            do_finish
          fi

          MEASUREMENT_COUNT=`expr $MEASUREMENT_COUNT + 1`
        #end packet size
        done
        if [ "x$MODE" != "xREBOOT" ]; then
          MODE=$RATEREPEATMODE
        fi
      #end rate
      done
      if [ "x$MODE" != "xREBOOT" ]; then
        MODE=$RATEREPEATMODE
      fi
    #end power
    done
    if [ "x$MODE" != "xREBOOT" ]; then
      MODE=$LINKREPEATMODE
    fi
  #end link
  done

  if [ "x$MODE" != "xREBOOT" ]; then
    MODE=$SCRIPTREPEATMODE
  fi

  echo "INIT_MEASUREMENT_COUNTER=$MEASUREMENT_COUNT" > measurement_counter_init.$MEASUREMENT_PREFIX

#end script
done

fi

if [ "x$PERFORMANCETEST" = "x1" ]; then
  exit 0
fi

MODE=REBOOT
LINKREPEATMODE=CLICK
RATEREPEATMODE=DRIVER
POSITIONREPEATMODE=REBOOT
REPEATMODE=CLICK
SCRIPTREPEATMODE=REBOOT

RUN_AT_LEAST_ONE_MEASURMENT=0

for params in $SCRIPTS; do
  . ./$params
  if [ -f ./measurement_counter_init.$MEASUREMENT_PREFIX ]; then
    . ./measurement_counter_init.$MEASUREMENT_PREFIX
  else
    INIT_MEASUREMENT_COUNTER=0
  fi
  echo "MEASUREMENT_COUNT=0" > measurment_counter.$MEASUREMENT_PREFIX
  echo "INIT_MEASUREMENT_COUNTER=$INIT_MEASUREMENT_COUNTER" >> measurment_counter.$MEASUREMENT_PREFIX
done

ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 3"
sleep 1

for p in $POSITIONS; do

  for params in $SCRIPTS; do

   . ./$params
   . ./measurment_counter.$MEASUREMENT_PREFIX

   for pow in $POWER; do
     for c in $CHANNEL_MOBIL; do
       for r in `seq 1 $COUNT_RATE_PAIRS`; do

        cat tmpl/mode.monitor | sed -e "s#VAR_CHANNEL#$CHANNEL_FIX#g" -e "s#VAR_POWER#$pow#g" > mode_fix.monitor

        RATE_1=`cat $params |  grep "#RATES" | awk '{print $2}' | sort -u | head -n $r | tail -n 1`
        HTMODE_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $1}'`
        if [ "x$HTMODE_1" = "xHT40" ]; then
          echo "HTMODE=\"HT40+\"" >> mode_fix.monitor
        fi

        BW_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $1}' | sed -e "s#HT20#0#g" -e "s#HT40#1#g"`
        HT_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $2}' | sed -e "s#NHT#false#g" -e "s#HT#true#g"`
        RATEINDEX_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $3}'`
        SGI_1=`echo $RATE_1 | sed "s#_# #g" | awk '{print $4}' | sed -e "s#0#false#g" -e "s#1#true#g"`

        cat tmpl/mode.monitor | sed -e "s#VAR_CHANNEL#$c#g" -e "s#VAR_POWER#$pow#g" > mode_mobile.monitor

        RATE_2=`cat $params |  grep "#RATES" | awk '{print $3}' | sort -u | head -n $r | tail -n 1`
        HTMODE_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $1}'`
        if [ "x$HTMODE_2" = "xHT40" ]; then
          echo "HTMODE=\"HT40+\"" >> mode_mobile.monitor
        fi

        BW_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $1}' | sed -e "s#HT20#0#g" -e "s#HT40#1#g"`
        HT_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $2}' | sed -e "s#NHT#false#g" -e "s#HT#true#g"`
        RATEINDEX_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $3}'`
        SGI_2=`echo $RATE_2 | sed "s#_# #g" | awk '{print $4}' | sed -e "s#0#false#g" -e "s#1#true#g"`

        if [ "$HT_1" = "true" ] && [ "$HT_2" = "true" ]; then
          PACKET_SIZE=$HTPACKETSIZE
        else
          PACKET_SIZE=$NONHTPACKETSIZE
        fi

        cat tmpl/$SENDER_TMPL | sed -e "s#PARAMS_RATEINDEX#$RATEINDEX_1#g" -e "s#PARAMS_MCS#$HT_1#g" -e "s#PARAMS_BANDWIDTH#$BW_1#g" -e "s#PARAMS_SGI#$SGI_1#g" -e "s#PARAMS_GF#$GF#g" -e "s#PACKET_SIZE#$PACKET_SIZE#g" > sender_fix.click

        cat tmpl/$SENDER_TMPL | sed -e "s#PARAMS_RATEINDEX#$RATEINDEX_2#g" -e "s#PARAMS_MCS#$HT_2#g" -e "s#PARAMS_BANDWIDTH#$BW_2#g" -e "s#PARAMS_SGI#$SGI_2#g" -e "s#PARAMS_GF#$GF#g" -e "s#PACKET_SIZE#$PACKET_SIZE#g" > sender_mobile.click

        for l in `seq 1 $COUNT_LINK_PAIRS`; do

          AC_LINK_PAIR=`cat $params |  grep "#LINKPAIRS" | head -n $l | tail -n 1`
          SENDER_1=`echo $AC_LINK_PAIR | awk '{print $2}'`
          RECEIVER_1=`echo $AC_LINK_PAIR | awk '{print $3}'`
          SENDER_2=`echo $AC_LINK_PAIR | awk '{print $4}'`
          RECEIVER_2=`echo $AC_LINK_PAIR | awk '{print $5}'`

          cat tmpl/aci.mes.tmpl | sed -e "s#RECEIVER1#$RECEIVER_1#g" -e "s#SENDER1#$SENDER_1#g" -e "s#RECEIVER2#$RECEIVER_2#g" -e "s#SENDER2#$SENDER_2#g" -e "s#WLANDEVICE#$WLANDEVICE#g" > aci.mes

          for rep in `seq 1 $REPETITION`; do

            FINALPATH=`echo "$MEASUREMENT_PREFIX\_$MEASUREMENT_COUNT\_pos_$p\_power_$pow\_channel_$c\_ratepair_$r\_link_$l\_rep_$rep\_monitor" | sed -e "s#\\\\\##g"`

            if [ ! -d $FINALPATH ]; then
              if [ "x$MODE" = "x" ]; then
                MODE=REBOOT
                echo "MODEERROR: $p $pow $c $r $l $rep" >> modeerror
              fi

              if [ "x$TEST" = "x1" ]; then
                TESTONLY=1 RUNMODE=$MODE run_measurement.sh aci.des $FINALPATH
              else
                RUNMODE=$MODE run_measurement.sh aci.des $FINALPATH
              fi

              RUN_AT_LEAST_ONE_MEASURMENT=1


              if [ ! -e $FINALPATH ]; then
                mkdir $FINALPATH
              fi

              (cd $FINALPATH; wget http://www2.informatik.hu-berlin.de/~sombrutz/pub/labs/webcam.jpeg )

              echo "MEASUREMENT=$MEASUREMENT_PREFIX" > $FINALPATH/params
              echo "POSITION=$p" >> $FINALPATH/params
              echo "POWER=$pow" >> $FINALPATH/params
              echo "FIX_CHANNEL=$CHANNEL_FIX" >> $FINALPATH/params
              echo "FIX_HTMODE=$HTMODE_1" >> $FINALPATH/params
              echo "FIX_SENDER=$SENDER_1" >> $FINALPATH/params
              echo "FIX_RECEIVER=$RECEIVER_1" >> $FINALPATH/params
              echo "FIX_RATEINDEX=$RATEINDEX_1" >> $FINALPATH/params
              echo "FIX_BW=$BW_1" >> $FINALPATH/params
              echo "FIX_HT=$HT_1" >> $FINALPATH/params
              echo "FIX_SGI=$SGI_1" >> $FINALPATH/params
              echo "FIX_PACKET_SIZE=$PACKET_SIZE" >> $FINALPATH/params

              echo "MOBILE_CHANNEL=$c" >> $FINALPATH/params
              echo "MOBILE_HTMODE=$HTMODE_2" >> $FINALPATH/params
              echo "MOBILE_SENDER=$SENDER_2" >> $FINALPATH/params
              echo "MOBILE_RECEIVER=$RECEIVER_2" >> $FINALPATH/params
              echo "MOBILE_RATEINDEX=$RATEINDEX_2" >> $FINALPATH/params
              echo "MOBILE_BW=$BW_2" >> $FINALPATH/params
              echo "MOBILE_HT=$HT_2" >> $FINALPATH/params
              echo "MOBILE_SGI=$SGI_2" >> $FINALPATH/params
              echo "MOBILE_PACKET_SIZE=$PACKET_SIZE" >> $FINALPATH/params

              cp ./$params $FINALPATH/

              MODE=$REPEATMODE

            fi

            if [ -f finish ]; then
              do_finish
            fi

            INIT_MEASUREMENT_COUNTER=`expr $INIT_MEASUREMENT_COUNTER + 1`

            ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"
            sleep 1

            if [ "x$MODE" != "xREBOOT" ]; then
              MODE=$REPEATMODE
            fi
          #end repeat
          done

          if [ "x$MODE" != "xREBOOT" ]; then
            MODE=$LINKREPEATMODE
          fi
        #end link direction
        done

        if [ "x$MODE" != "xREBOOT" ]; then
          MODE=$RATEREPEATMODE
        fi
       #end rate
       done

#
#
#  INIT
#
#

       if [ "x$INIT_MEASURMENT" = "x1" ]; then

        cat tmpl/mode.monitor | sed -e "s#VAR_CHANNEL#$CHANNEL_FIX#g" -e "s#VAR_POWER#$pow#g" > mode_fix.monitor

        RATE=`cat $params |  grep "#TESTRATE" | awk '{print $2}' | sort -u | head -n 1`
        HTMODE=`echo $RATE | sed "s#_# #g" | awk '{print $1}'`
        if [ "x$HTMODE" = "xHT40" ]; then
          echo "HTMODE=\"HT40+\"" >> mode_fix.monitor
        fi

        BW=`echo $RATE | sed "s#_# #g" | awk '{print $1}' | sed -e "s#HT20#0#g" -e "s#HT40#1#g"`
        HT=`echo $RATE | sed "s#_# #g" | awk '{print $2}' | sed -e "s#NHT#false#g" -e "s#HT#true#g"`
        RATEINDEX=`echo $RATE | sed "s#_# #g" | awk '{print $3}'`
        SGI=`echo $RATE | sed "s#_# #g" | awk '{print $4}' | sed -e "s#0#false#g" -e "s#1#true#g"`

        cat tmpl/mode.monitor | sed -e "s#VAR_CHANNEL#$c#g" -e "s#VAR_POWER#$pow#g" > mode_mobile.monitor

        if [ "$HT" = "true" ]; then
          PACKET_SIZE=$HTPACKETSIZE
        else
          PACKET_SIZE=$NONHTPACKETSIZE
        fi

        cat tmpl/$SENDER_TMPL | sed -e "s#PARAMS_RATEINDEX#$RATEINDEX#g" -e "s#PARAMS_MCS#$HT#g" -e "s#PARAMS_BANDWIDTH#$BW#g" -e "s#PARAMS_SGI#$SGI#g" -e "s#PARAMS_GF#$GF#g" -e "s#PACKET_SIZE#$PACKET_SIZE#g" > sender_fix.click

        NODES=`cat $params | grep "#LINKPAIRS" | head -n 1 | sed "s/#LINKPAIRS//g"`

        for n in $NODES; do

          RESTNODES=`echo $NODES | sed "s#$n##g"`
          RECEIVER_1=`echo $RESTNODES | awk '{print $1}'`
          RECEIVER_2=`echo $RESTNODES | awk '{print $2}'`
          RECEIVER_3=`echo $RESTNODES | awk '{print $3}'`

          cat tmpl/init_measurement.mes.tmpl | sed -e "s#RECEIVER1#$RECEIVER_1#g" -e "s#RECEIVER2#$RECEIVER_2#g" -e "s#RECEIVER3#$RECEIVER_3#g" -e "s#SENDER#$n#g" -e "s#WLANDEVICE#$WLANDEVICE#g" > aci.mes

          FINALPATH=`echo "$MEASUREMENT_PREFIX\_init_$INIT_MEASUREMENT_COUNTER\_ht_$HT\_pow_$pow\_rate_1\_channel_$CHANNEL_FIX\_channel_mobil_\$c\_link_1_monitor" | sed -e "s#\\\\\##g"`

          if [ ! -d $FINALPATH ]; then
            if [ "x$MODE" = "x" ]; then
              MODE=REBOOT
              echo "MODEERROR: $p $pow $c $r" >> modeerror
            fi

            if [ "x$TEST" = "x1" ]; then
              TESTONLY=1 RUNMODE=$MODE run_measurement.sh aci.des $FINALPATH
            else
              RUNMODE=$MODE run_measurement.sh aci.des $FINALPATH
            fi

            RUN_AT_LEAST_ONE_MEASURMENT=1

            if [ ! -e $FINALPATH ]; then
              mkdir $FINALPATH
            fi

            (cd $FINALPATH; wget http://www2.informatik.hu-berlin.de/~sombrutz/pub/labs/webcam.jpeg )

            echo "MEASUREMENT=$MEASUREMENT_PREFIX" > $FINALPATH/params
            echo "POSITION=-$p" >> $FINALPATH/params
            echo "POWER=$pow" >> $FINALPATH/params
            echo "FIX_CHANNEL=$CHANNEL_FIX" >> $FINALPATH/params
            echo "FIX_HTMODE=$HTMODE" >> $FINALPATH/params
            echo "FIX_SENDER=$n" >> $FINALPATH/params
            echo "FIX_RECEIVER=$RECEIVER_1" >> $FINALPATH/params
            echo "FIX_RATEINDEX=$RATEINDEX" >> $FINALPATH/params
            echo "FIX_BW=$BW" >> $FINALPATH/params
            echo "FIX_HT=$HT" >> $FINALPATH/params
            echo "FIX_SGI=$SGI" >> $FINALPATH/params
            echo "FIX_PACKET_SIZE=$PACKET_SIZE" >> $FINALPATH/params

            echo "MOBILE_CHANNEL=$c" >> $FINALPATH/params
            echo "MOBILE_HTMODE=$HTMODE" >> $FINALPATH/params
            echo "MOBILE_SENDER=$RECEIVER_2" >> $FINALPATH/params
            echo "MOBILE_RECEIVER=$RECEIVER_3" >> $FINALPATH/params
            echo "MOBILE_RATEINDEX=$RATEINDEX" >> $FINALPATH/params
            echo "MOBILE_BW=$BW" >> $FINALPATH/params
            echo "MOBILE_HT=$HT" >> $FINALPATH/params
            echo "MOBILE_SGI=$SGI" >> $FINALPATH/params
            echo "MOBILE_PACKET_SIZE=$PACKET_SIZE" >> $FINALPATH/params

            cp ./$params $FINALPATH/

            MODE=$REPEATMODE
          fi

          if [ -f finish ]; then
            do_finish
          fi

          INIT_MEASUREMENT_COUNTER=`expr $INIT_MEASUREMENT_COUNTER + 1`

          ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 1"
          sleep 1

          if [ "x$MODE" != "xREBOOT" ]; then
            MODE=DRIVER
          fi
        #end node
        done

       fi

#
#
#  END INIT
#
#

       if [ "x$MODE" != "xREBOOT" ]; then
         MODE=$RATEREPEATMODE
       fi
      #end channel
      done

      if [ "x$MODE" != "xREBOOT" ]; then
        MODE=$RATEREPEATMODE
      fi
    #end power
    done

    if [ "x$MODE" != "xREBOOT" ]; then
     MODE=$SCRIPTREPEATMODE
    fi

    echo "MEASUREMENT_COUNT=$MEASUREMENT_COUNT" > measurment_counter.$MEASUREMENT_PREFIX
    echo "INIT_MEASUREMENT_COUNTER=$INIT_MEASUREMENT_COUNTER" >> measurment_counter.$MEASUREMENT_PREFIX

  #end params
  done

  if [ "x$MODE" != "xREBOOT" ]; then
    MODE=$POSITIONREPEATMODE
  fi

  if [ $RUN_AT_LEAST_ONE_MEASURMENT -eq 1 ]; then
    #change position
    ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/motor.sh $POSITION_STEP_DIRECTION $POSITION_STEP_LENGTH"
    sleep 1;
  fi

  ssh testbed@192.168.4.124 "/testbedhome/testbed/helper/host/lib/legoMindstorm/bin/beep.sh 3"

done

do_finish

exit 0
