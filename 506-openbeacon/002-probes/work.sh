#!/bin/bash

echo "working ..."

mess=1 
channel=82
burst=1
packetsize=8

function work() {
# Parameter:  $1=channel, $2=bitrate, $3=power, $4=speed, $5=burst, $6=number, $7=packetsize, $8=sleep
	cat sender.click.tmp | sed s/PARPACKETSIZE/$7/ | sed s/PARBURST/$5/ | sed s/PARCHANNEL/$1/ | sed s/PARRATE/$2/ | sed s/PARPOWER/$3/ | sed s/PARINTERVAL/$4/ > sender_work.click
	cat receiver.click.tmp | sed s/PARPACKETSIZE/$7/ | sed s/PARBURST/$5/ | sed s/PARCHANNEL/$1/ | sed s/PARRATE/$2/ | sed s/PARPOWER/$3/ | sed s/PARINTERVAL/$4/ > receiver_work.click

	mdir="openbeacon_"$6
	RUNMODE=REBOOT run_measurement.sh sender_and_receiver.des $mdir

	echo "channel:     "$1 >  $mdir/parameter.log
	echo "bitrate:     "$2 >> $mdir/parameter.log
	echo "power:       "$3 >> $mdir/parameter.log
	echo "speed:       "$4 >> $mdir/parameter.log
	echo "burst:       "$5 >> $mdir/parameter.log
	echo "packet size: "$7 >> $mdir/parameter.log
	
	for i in `cat nodes`;
	do
		fromdump.sh $mdir/$i.obd0.raw.dump > $mdir/$i.obd0.raw.erg
	done

	sleep $8
}


for bitrate in 2 4; 
do
	for power in 1 2 3 4;
	do    
		mdir="openbeacon_"$mess
		burst=1
		for speed in 100 50 33 25;
		do
			work $channel $bitrate $power $speed $burst $mess $packetsize 10

			mdir="openbeacon_"$mess

			for i in `cat nodes`;
			do
				cat $mdir/$i.obd0.raw.erg | cut -d " " -f7,8,10,1 | replace : " " > $mdir/$i.obd0.raw_rx.erg
			done
			mess=$[$mess+1]
		done
		speed=100
		for burst in 4 5 6 7 8 9 10 11 12
		do
			work $channel $bitrate $power $speed $burst $mess $packetsize 10
			mdir="openbeacon_"$mess

			for i in `cat nodes`;
			do
				cat $mdir/$i.obd0.raw.erg | cut -d " " -f7,8,10,1 | replace : " " > $mdir/$i.obd0.raw_rx.erg
			done
			mess=$[$mess+1]
		done
	done
done
	 

