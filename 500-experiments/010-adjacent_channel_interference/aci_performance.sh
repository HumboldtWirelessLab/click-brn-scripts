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

for frequ in 5Ghz.setup 2_4Ghz.setup; do

  PREFIX=`echo $frequ | sed "s#\.setup##g"`

  for burst in 1; do
    for pcap in yes no; do
      echo "$burst $pcap"
      echo "#define PACKETBURST $burst" > performance.click

      if [ "x$pcap" = "xyes" ]; then
        echo "#define ENABLE_PCAP" >> performance.click
      fi

      PERFORMANCETEST=1 ./aci_measurement.sh $frequ

      AC_PATH=`echo "$PREFIX\_burst_$burst\_pcap_$pcap\_brndev_0" | sed -e "s#\\\\\##g"`

      mkdir $AC_PATH
      mv init* $AC_PATH
    done
  done

  for pcap in yes no; do
    echo "$burst $pcap"
    echo "#define USEBRNDEVICE" > performance.click
    echo "#define PACKETBURST $burst" >> performance.click

    if [ "x$pcap" = "xyes" ]; then
      echo "#define ENABLE_PCAP" >> performance.click
    fi

    PERFORMANCETEST=1 ./aci_measurement.sh $frequ

    AC_PATH=`echo "$PREFIX\_burst_1_pcap_$pcap\_brndev_1" | sed -e "s#\\\\\##g"`

    mkdir $AC_PATH
    mv init* $AC_PATH
  done

done

exit 0
