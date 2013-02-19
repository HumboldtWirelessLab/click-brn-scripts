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

if [ "x$1" = "xclear" ]; then
  rm -f sender.click sender_nocca.click monitor monitor_nocca sender_and_receiver.mes
  exit 0
fi

#SCENARIOS="check hiddennode inrange weak none"
#SCENARIOS="none"
SCENARIOS="check"

#seismo162 seismo176 foobar103 wgt55

for s in $SCENARIOS; do

CW=1

case "$s" in
    "check")
        #SENDER="seismo176"
        SENDER="seismo162"
        RECEIVER="foobar103"
        DISRUPTER=""
        TXPOWER=17
        TXINTERVAL=12
        DISTXINTERVAL=0
        DISPKTSIZE=0
        ;;
    "hiddennode")
        SENDER="seismo176"
        RECEIVER="foobar103"
        DISRUPTER="wgt55"
        TXPOWER=15
        TXINTERVAL=12
        DISTXINTERVAL=25
        DISPKTSIZE=100
        ;;
    "inrange")
        SENDER="seismo162 seismo176 wgt55"
        RECEIVER="foobar103"
        DISRUPTER=""
        TXINTERVAL=12
        TXPOWER=15
        DISTXINTERVAL=0
        DISPKTSIZE=0
        CW=0
        ;;
    "weak")
        SENDER="seismo162"
        RECEIVER="foobar103"
        DISRUPTER=""
        TXINTERVAL=12
        TXPOWER=0
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
      *)
        echo "Unknown scenario"
        continue;
       ;;
esac



cat sender.click.tmpl | sed "s#PARAM_TXINTERVAL#$TXINTERVAL#g" > sender.click
cat sender_nocca.click.tmpl | sed "s#PARAM_DISPI#$DISTXINTERVAL#g" | sed "s#PARAM_DISPS#$DISPKTSIZE#g" > sender_nocca.click

cat monitor.tmpl | sed "s#PARAM_TXPOWER#$TXPOWER#g" > monitor
cat monitor_nocca.tmpl > monitor_nocca

if [ "x$CW" = "x0" ]; then
  echo "CWMAX=\"1 1 1 1\"" >> monitor
  echo "CWMIN=\"1 1 1 1\"" >> monitor
fi

echo -n "" > sender_and_receiver.mes

for i in $SENDER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - sender.click LOGDIR/NODENAME.NODEDEVICE.log - -" >> sender_and_receiver.mes
done

for i in $DISRUPTER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor_nocca - sender_nocca.click LOGDIR/NODENAME.NODEDEVICE.log - -" >> sender_and_receiver.mes
done

for i in $RECEIVER; do
  echo "$i DEV0 BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION - monitor - receiver.click LOGDIR/NODENAME.NODEDEVICE.log CONFIGDIR/regmon_node.sh LOGDIR/app.log" >> sender_and_receiver.mes
done

RUNMODE=ENVIRONMENT run_measurement.sh sender_and_receiver.des $s

mkdir $s/setup
cp sender.click sender_nocca.click monitor_nocca monitor sender_and_receiver.mes $s/setup

echo "SCENARIO=$s" > $s/params
echo "SENDER=\"$SENDER\"" >> $s/params
echo "RECEIVER==\"$RECEIVER\"" >> $s/params
echo "DISRUPTER=\"$DISRUPTER\"" >> $s/params
echo "TXINTERVAL=\"$TXINTERVAL\"" >> $s/params
echo "TXPOWER=\"$TXPOWER\"" >> $s/params
echo "DISTXINTERVAL=\"$DISTXINTERVAL\"" >> $s/params
echo "DISPKTSIZE=\"$DISPKTSIZE\"" >> $s/params
echo "CW=\"$CW\"" >> $s/params

$0 clear

done

