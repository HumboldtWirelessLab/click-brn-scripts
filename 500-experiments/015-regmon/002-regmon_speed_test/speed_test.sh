#!/bin/sh


#SPEEDS="10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"
SPEEDS="10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100"

MODE=REBOOT

for i in $SPEEDS; do

  if [ ! -e $i ]; then
    echo "INTERVAL=$i" > ./interval

    RUNMODE=$MODE run_measurement.sh sender_and_receiver.des $i

    MODE=DRIVER
  fi

done

rm -f ./interval
