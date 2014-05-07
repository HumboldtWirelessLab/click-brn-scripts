#!/bin/bash

X0=0;
Y0=0;

if [ ! -e $3 ]; then X0=$3; fi
if [ ! -e $4 ]; then Y0=$4; fi

X=$X0;
Y=$Y0;

Z=0;
I=1;

if [ -e boid.plm ]; then rm -f boid.plm; fi

touch boid.plm;

case $2 in
"line")

while [ "$I" -lt $(($1+1)) ]
do
	echo "sk$I $X $Y $Z" >> boid.plm;
	I=$(($I + 1));
	if [ "$X" -lt "$Y" ]; then 
	X=$(($X+50));
	else
	Y=$(($Y+50));
	fi
done ;

if [ -e boid.mes ]; then rm -f boid.mes; fi

touch boid.mes;

echo "#NODE		DEVICE	MODULSDIR					 MODOPTIONS WIFICONFIG			CLICKMODDIR	CLICKSCRIPT			CLICKLOGFILE			APPLICATION	APPLICATIONLOGFILE
random:$1	DEV0	BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION -	    monitor.b.channel		-		boid.click		LOGDIR/NODENAME.NODEDEVICE.log	-		-" \
 >> boid.mes;
 
 echo "Set initial Node Placement to $1 Nodes in a Line.";;

"cubic")
I1=0;
I2=0;
while [ "$I1" -lt $(($1)) ]
	do
	while [ "$I2" -lt $(($1)) ]
		do
		echo "sk$I $X $Y $Z" >> boid.plm;
		I=$(($I+1));
		I2=$(($I2 + 1));
		X=$(($X+50));
		done;
	I2=0;
	X=$X0;
	I1=$(($I1+1));
	Y=$(($Y+50));
	done ;

if [ -e boid.mes ]; then rm -f boid.mes; fi

touch boid.mes;

echo "#NODE		DEVICE	MODULSDIR					 MODOPTIONS WIFICONFIG			CLICKMODDIR	CLICKSCRIPT			CLICKLOGFILE			APPLICATION	APPLICATIONLOGFILE
random:$(($1*$1))	DEV0	BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION -	    monitor.b.channel		-		boid.click		LOGDIR/NODENAME.NODEDEVICE.log	-		-" \
 >> boid.mes;
 
 echo "Set initial Node Placement to $(($1*$1)) Nodes in a cube.";;
	

	
*)
echo "Wrong second parameter";
echo "Usage: ./placement.sh [number] [line|cubic]";
esac

exit 0