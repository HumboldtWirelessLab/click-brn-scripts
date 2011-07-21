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

for frequ in 5Ghz_small.setup; do

  PREFIX=`echo $frequ | sed "s#\.setup##g"`

  for burst in 1; do
    for pcap in no; do
      echo "$burst $pcap"
      echo "#define PACKETBURST $burst" > performance.click

      PERFORMANCETEST=1 ./aci_measurement.sh $frequ

      AC_PATH=`echo "$PREFIX\_burst_$burst\_pcap_$pcap\_brndev_0" | sed -e "s#\\\\\##g"`

      mkdir $AC_PATH
      mv init* $AC_PATH
    done
  done

done

exit 0
