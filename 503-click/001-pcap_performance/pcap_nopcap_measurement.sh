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


RUNS=`seq 1 10`
NUM=1

for r in $RUNS; do

#PCAP
cat ./tmpl/pcap_performance.click | sed "s#NOPCAP#USE_PCAP#g" > ./pcap_performance.click

FINALPATH=$NUM\_pcap
RUNMODE=REBOOT run_measurement.sh pcap_performance.des $FINALPATH

NUM=`expr $NUM + 1`

#NOPCAP
cat ./tmpl/pcap_performance.click > ./pcap_performance.click

FINALPATH=$NUM\_nopcap
RUNMODE=REBOOT run_measurement.sh pcap_performance.des $FINALPATH

NUM=`expr $NUM + 1`

done

rm -rf ./pcap_performance.click

exit 0
