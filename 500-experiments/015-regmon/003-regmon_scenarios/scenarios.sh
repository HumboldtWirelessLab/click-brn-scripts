#!/bin/sh


#ACI
#
#  Tutor                    Ich                     Tolja              Besprechungsraum
#
#  seismo158                seismo151               seismo176(TX)            commander105
#
#
#                                                                    seismo162(TX)  foobar103


#Hidden Node
#
#  Tutor                    Ich                     Tolja           Besprechungsraum
#
#  seismo158(TX)            seismo151(TX)           commander105      seismo162(TX)
#
#
#                                                   seismo176          foobar103

#Weak
#
#  Tutor                    Ich                     Tolja           Besprechungsraum
#
#  seismo158(TX)            seismo151(TX)           commander105      foobar103
#
#
#                                                   seismo176         seismo162

#Inrage
#
#  Tutor                    Ich                     Tolja           Besprechungsraum
#
#                                                   commander105      foobar103
#
#                                                                     seismo162(TX)
#                                                                     seismo176(TX)
#                                                                     seismo151(TX)
#                                                                     seismo158(TX)


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
  if [ "x$1" = "xclear" ]; then
    rm -f sender.click sender_nocca.click monitor monitor_nocca monitor_aci sender_and_receiver.mes sender_aci.click
    exit 0
  else
    SCENARIOS=$1
  fi
fi


if [ "x$SCENARIOS" = "x" ]; then
  #SCENARIOS="check hiddennode inrange weak none"
  #SCENARIOS="none"
  SCENARIOS="aci"
fi

#seismo162 seismo176 foobar103 wgt55

for s in $SCENARIOS; do

CW=1
if [ "x$DISTXPOWER" = "x" ]; then
  DISTXPOWER=36
fi
if [ "x$TXPOWER" = "x" ]; then
  TXPOWER=36
fi
if [ "x$TXRATE" = "x" ]; then
  TXRATE=12
fi

if [ "x$TXBURST" = "x" ]; then
  TXBURST=1
fi

if [ "x$CHANNEL" = "x" ]; then
  CHANNEL=46
fi



TXINTERVAL=12
PKTSIZE=2200
DISTXINTERVAL=12
DISPKTSIZE=500
DISTXBURST=1

PASSIVERECEIVER=""

ACIRECEIVER=""
ACISENDER=""

NOSYNCSENDER=""

case "$s" in
    "check")
        #SENDER="seismo176"
        SENDER="seismo158"
        RECEIVER="foobar103"
        DISRUPTER=""
        TXPOWER=17
        TXINTERVAL=12
        DISTXINTERVAL=0
        DISPKTSIZE=0
        ;;
    "hiddennode")
        #SENDER="seismo162"
        #RECEIVER="commander105 foobar103"
        #PASSIVERECEIVER="seismo176 seismo158"
        SENDER="seismo151"
        RECEIVER="commander105 foobar103"
        PASSIVERECEIVER="seismo162 seismo158"
        TXINTERVAL=12
        PKTSIZE=2200
        TXBURST=1
        #DISRUPTER="seismo151"
        DISRUPTER="seismo176"
        DISTXINTERVAL=6
        #12
        DISPKTSIZE=100
        DISTXBURST=1
        ;;
    "hiddennode_test")
        SENDER="seismo162 seismo158 seismo151"
        RECEIVER="commander105 foobar103"
        PASSIVERECEIVER="seismo176"
        TXINTERVAL=12
        PKTSIZE=2200
        TXBURST=1
        DISRUPTER=""
        DISTXINTERVAL=12
        DISPKTSIZE=2200
        DISTXBURST=1
        ;;
    "inrange")
        SENDER="seismo162"
        NOSYNCSENDER="seismo176 seismo151 seismo158"
        RECEIVER="foobar103 commander105"
        DISRUPTER=""
        PKTSIZE=2200
        TXINTERVAL=12
        if [ "x$TXBURST" = "x" ]; then
          TXBURST=1
        fi
        DISTXINTERVAL=$TXINTERVAL
        DISPKTSIZE=$PKTSIZE
        DISTXBURST=$TXBURST
        DISTXPOWER=$TXPOWER
        CW=0
        ;;
    "weak")
        #SENDER="seismo158"
        SENDER="seismo151"
        RECEIVER="foobar103 commander105"
        PASSIVERECEIVER="seismo176 seismo162 seismo158"
        #seismo151 seismo158
        TXINTERVAL=12
        PKTSIZE=2200
        TXBURST=1
        DISRUPTER=""
        if [ "x$TXPOWER" = "x" ]; then
          TXPOWER=63
        fi
        if [ "x$TXRATE" = "x" ]; then
          TXRATE=12
        fi
        DISTXINTERVAL=0
        DISPKTSIZE=0
        ;;
    "aci")
        SENDER="seismo176"
        RECEIVER="commander105"
        PASSIVERECEIVER="seismo158 seismo151"
        ACIRECEIVER="foobar103"
        ACISENDER="seismo162"
        DISRUPTER=""
        TXINTERVAL=12
        PKTSIZE=2200
        TXBURST=1
        if [ "x$TXPOWER" = "x" ]; then
          TXPOWER=63
        fi
        if [ "x$TXRATE" = "x" ]; then
          TXRATE=12
        fi
        DISTXINTERVAL=12
        DISPKTSIZE=2200
        DISTXBURST=1
        ;;
    "aci_acilink")
        SENDER="seismo162"
        RECEIVER="foobar103 commander105"
        PASSIVERECEIVER="seismo158"
        ACIRECEIVER=""
        ACISENDER=""
        DISRUPTER=""
        TXINTERVAL=12
        if [ "x$TXPOWER" = "x" ]; then
          TXPOWER=63
        fi
        if [ "x$TXRATE" = "x" ]; then
          TXRATE=12
        fi
        DISTXINTERVAL=12
        DISPKTSIZE=150
        ;;
    "aci_noacilink")
        SENDER="seismo176"
        RECEIVER="commander105 foobar103"
        PASSIVERECEIVER="seismo158"
        ACIRECEIVER=""
        ACISENDER=""
        DISRUPTER=""
        TXINTERVAL=12
        if [ "x$TXPOWER" = "x" ]; then
          TXPOWER=63
        fi
        if [ "x$TXRATE" = "x" ]; then
          TXRATE=12
        fi
        DISTXINTERVAL=0
        DISPKTSIZE=0
        ;;
    "none")
        SENDER=""
        RECEIVER="foobar103"
        DISRUPTER=""
        TXINTERVAL=12
        TXPOWER=0
        DISTXINTERVAL=0
        DISPKTSIZE=0
        ;;
    "micro")
        SENDER=""
        RECEIVER="foobar103"
        PASSIVERECEIVER=""
        TXINTERVAL=12
        PKTSIZE=2200
        TXBURST=1
        DISRUPTER=""
        DISTXINTERVAL=12
        DISPKTSIZE=2200
        DISTXBURST=1
        ;;
      *)
        echo "Unknown scenario"
        continue;
       ;;
esac



cat sender.click.tmpl | sed "s#PARAM_TXINTERVAL#$TXINTERVAL#g" | sed "s#PARAM_TXPOWER#$TXPOWER#g" | sed "s#PARAM_TXRATE#$TXRATE#g" | sed "s#PARAM_TXBURST#$TXBURST#g" | sed "s#PARAM_PKTSIZE#$PKTSIZE#g" > sender.click
cat sender_nocca.click.tmpl | sed "s#PARAM_DISPI#$DISTXINTERVAL#g" | sed "s#PARAM_DISPS#$DISPKTSIZE#g" | sed "s#PARAM_DISTXPOWER#$DISTXPOWER#g" | sed "s#PARAM_DISTXBURST#$DISTXBURST#g" | sed "s#PARAM_TXRATE#$TXRATE#g" > sender_nocca.click
cat sender_nocca.click.tmpl | sed "s#PARAM_DISPI#$DISTXINTERVAL#g" | sed "s#PARAM_DISPS#$DISPKTSIZE#g" | sed "s#PARAM_DISTXPOWER#$DISTXPOWER#g" | sed "s#PARAM_DISTXBURST#$DISTXBURST#g" | sed "s#PARAM_TXRATE#$TXRATE#g" > sender_aci.click

cat monitor.tmpl | sed "s#PARAM_TXPOWER#$TXPOWER#g" | sed "s#PARAM_CHANNEL#$CHANNEL#g" > monitor
cat monitor_nocca.tmpl | sed "s#PARAM_DISTXPOWER#$DISTXPOWER#g" | sed "s#PARAM_CHANNEL#$CHANNEL#g" > monitor_nocca

if [ "x$CW" = "x0" ]; then
  echo "CWMAX=\"1 1 1 1\"" >> monitor
  echo "CWMIN=\"1 1 1 1\"" >> monitor
fi

echo -n "" > sender_and_receiver.mes

for i in $SENDER; do
#  if [ "x$s" = "xhiddennode" ]; then
#    echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor_nocca - sender.click LOGDIR/NODENAME.NODEDEVICE.log - -" >> sender_and_receiver.mes
#  else
    echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - sender.click LOGDIR/NODENAME.NODEDEVICE.log - -" >> sender_and_receiver.mes
#  fi
done

for i in $DISRUPTER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor_nocca - sender_nocca.click LOGDIR/NODENAME.NODEDEVICE.log - -" >> sender_and_receiver.mes
done

for i in $RECEIVER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - receiver.click LOGDIR/NODENAME.NODEDEVICE.log CONFIGDIR/regmon_node.sh LOGDIR/app_NODENAME.log" >> sender_and_receiver.mes
  #echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - receiver.click /dev/null CONFIGDIR/regmon_node.sh /dev/null" >> sender_and_receiver.mes
done

for i in $PASSIVERECEIVER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - receiver.click LOGDIR/NODENAME.NODEDEVICE.log - -" >> sender_and_receiver.mes
done

for i in $ACIRECEIVER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - receiver.click LOGDIR/NODENAME.NODEDEVICE.log CONFIGDIR/regmon_node_aci.sh LOGDIR/app_NODENAME.log" >> sender_and_receiver.mes
  #echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - receiver.click /dev/null CONFIGDIR/regmon_node_aci.sh /dev/null" >> sender_and_receiver.mes
done

for i in $ACISENDER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - sender_aci.click LOGDIR/NODENAME.NODEDEVICE.log CONFIGDIR/channelswitch_node_aci.sh LOGDIR/app_NODENAME.log" >> sender_and_receiver.mes
done

for i in $NOSYNCSENDER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - sender_aci.click LOGDIR/NODENAME.NODEDEVICE.log - -" >> sender_and_receiver.mes
done

if [ "x$RUNMODE" = "x" ]; then
  RUNMODE=ENVIRONMENT
fi

RUNMODE=$RUNMODE run_measurement.sh sender_and_receiver.des $s$MEASUREMENTPOSTFIX

mkdir $s$MEASUREMENTPOSTFIX/setup
cp sender.click sender_nocca.click monitor_nocca monitor sender_and_receiver.mes $s$MEASUREMENTPOSTFIX/setup

echo "SCENARIO=$s" > $s$MEASUREMENTPOSTFIX/params
echo "SENDER=\"$SENDER\"" >> $s$MEASUREMENTPOSTFIX/params
echo "RECEIVER==\"$RECEIVER\"" >> $s$MEASUREMENTPOSTFIX/params
echo "DISRUPTER=\"$DISRUPTER\"" >> $s$MEASUREMENTPOSTFIX/params
echo "TXINTERVAL=\"$TXINTERVAL\"" >> $s$MEASUREMENTPOSTFIX/params
echo "TXPOWER=\"$TXPOWER\"" >> $s$MEASUREMENTPOSTFIX/params
echo "DISTXINTERVAL=\"$DISTXINTERVAL\"" >> $s$MEASUREMENTPOSTFIX/params
echo "DISPKTSIZE=\"$DISPKTSIZE\"" >> $s$MEASUREMENTPOSTFIX/params
echo "CW=\"$CW\"" >> $s$MEASUREMENTPOSTFIX/params

$0 clear

done
