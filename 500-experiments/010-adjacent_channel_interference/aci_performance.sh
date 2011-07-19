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

for burst in 1; do
  for pcap in yes no; do
    echo "$burst $pcap"
    echo "#define PACKETBURST $burst" > performance.click

    if [ "x$pcap" = "xyes" ]; then
      echo "#define ENABLE_PCAP" >> performance.click
    fi

    ./aci_measurement.sh ./5Ghz.setup

    AC_PATH="burst_$burst\_pcap_$pcap\_brndev_0"

    mkdir $AC_PATH
    mv init* $AC_PATH
  done
done

for pcap in yes no; do
  echo "$burst $pcap"
  echo "#define USEBRNDEVICE" >> performance.click
  echo "#define PACKETBURST $burst" > performance.click

  if [ "x$pcap" = "xyes" ]; then
    echo "#define ENABLE_PCAP" >> performance.click
  fi

  ./aci_measurement.sh ./5Ghz.setup

  AC_PATH="burst_1_pcap_$pcap\_brndev_1"

  mkdir $AC_PATH
  mv init* $AC_PATH
done

exit 0
