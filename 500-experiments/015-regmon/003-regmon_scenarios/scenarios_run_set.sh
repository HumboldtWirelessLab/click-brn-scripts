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

if [ "x$1" != "x" ]; then
  SETNAME=$1
fi

if [ "x$SETNAME" = "x" ]; then
  SETNAME="weak"
fi

if [ "x$SETNAME" = "xweak" ]; then

  #TXPOWERS="36 34 32 30 28 26 24 22 20 18 16 14 12 10 9 8 7 6 5 4 2"
  #TXRATES="12 18 48 72"
  #TXPOWERS="22 21 20 19 18 17 16 15 14 13 12"

  #TXPOWERS="36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0"
  TXPOWERS=`seq 0 36`
  #TXRATES="2 22"

  #TXPOWERS="0 2 4 6 18 36"
  TXRATES="2"

  #TXPOWERS="0"
  #TXRATES="2"

  RUNMODE=REBOOT
  #RUNMODE=ENVIRONMENT

  for p in $TXPOWERS; do
    for r in $TXRATES; do
      if [ ! -e weak_power.$p.rate.$r ]; then
        RUNMODE=$RUNMODE TXPOWER=$p TXRATE=$r MEASUREMENTPOSTFIX="_power.$p.rate.$r" ./scenarios.sh weak

        RUNMODE=CLICK
      fi
    done
  done

fi

if [ "x$SETNAME" = "xaci" ]; then

  #RUNMODE=ENVIRONMENT TXPOWER=63 TXRATE=12 DISTXPOWER=63 SCENARIOS=aci_acilink ./scenarios.sh
  #RUNMODE=ENVIRONMENT TXPOWER=63 TXRATE=12 DISTXPOWER=63 SCENARIOS=aci_noacilink ./scenarios.sh

  TXPOWERS=`seq 13 20`
  DISTTXPOWERS=`seq 10 35`

  RUNMODE=ENVIRONMENT

  for d in $DISTTXPOWERS; do
    for p in $TXPOWERS; do
      if [ ! -e aci_power.$p.distpower.$d ]; then
        RUNMODE=$RUNMODE TXPOWER=$p TXRATE=12 DISTXPOWER=$d MEASUREMENTPOSTFIX="_power.$p.distpower.$d" ./scenarios.sh aci
        RUNMODE=CLICK
      fi
    done
  done

fi

if [ "x$SETNAME" = "xhidden" ]; then

  if [ ! -e hiddennode_test ]; then
    RUNMODE=ENVIRONMENT TXPOWER=63 TXRATE=12 DISTXPOWER=63 SCENARIOS=hiddennode_test ./scenarios.sh
  fi

  #TXPOWERS="30 35 25 20"
  #TXPOWERS="35 30 25 20 15 10 5"
  TXPOWERS="10 8 6 4 2 1"
  #DISTTXPOWERS="35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15"
  DISTTXPOWERS="35"

  RUNMODE=ENVIRONMENT

  for d in $DISTTXPOWERS; do
    for p in $TXPOWERS; do
      if [ ! -e hiddennode_power.$p.distpower.$d ]; then
        RUNMODE=$RUNMODE TXPOWER=$p TXRATE=12 DISTXPOWER=$d MEASUREMENTPOSTFIX="_power.$p.distpower.$d" ./scenarios.sh hiddennode
        RUNMODE=CLICK
      fi
    done
  done

fi

if [ "x$SETNAME" = "xinrange" ]; then

  #TXPOWERS="36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2"
  #TXRATES="2 12"
  TXPOWERS="36 30 25"
  TXRATES="12 18 24 36 24"

  RUNMODE=ENVIRONMENT

  for r in $TXRATES; do

    if [ $r -eq 2 ]; then
      CHANNELS="14"
      TXBURST=1
    else
      CHANNELS="46"
      #CHANNELS="46 13"
      TXBURST=`calc round\(4\*$r/12\) | awk '{print $1}'`
    fi

    for c in $CHANNELS; do
      for p in $TXPOWERS; do
        if [ ! -e inrange_power.$p.rate.$r ]; then
          RUNMODE=$RUNMODE TXBURST=$TXBURST TXPOWER=$p TXRATE=$r CHANNEL=$c MEASUREMENTPOSTFIX="_power.$p.rate.$r" ./scenarios.sh inrange

          RUNMODE=CLICK
        fi
      done
      mkdir inrange_channel_$c.rate.$r
      mv inrange_power* inrange_channel_$c.rate.$r
      RUNMODE=ENVIRONMENT
    done
  done
fi
