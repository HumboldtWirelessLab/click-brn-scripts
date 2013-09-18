#!/bin/bash

dirname="";

#laufvariable
I=0;

#initiale steuerungsfaktoren
radius=30;
separation=10000;
cohesion=-20;
steerlimit=10000;
gravitation=1000000;
speed=4;


#stellschräubchen für die simulationen
nodes=3;
maxnodes=6;
radIncrements=5;

method="$1";
nodeplm="cubic";

if [ -e "$method" ]; then rm -rf "$method"; fi

while [ "$nodes" -lt "$maxnodes" ]
do
	
	placement.sh $nodes $nodeplm;
	I=0;
	radius=30;
	while [ "$I" -lt $radIncrements ]
	do

		if [ -e config.click ]; then rm -f config.click;  fi

		echo \
		"##define DEBUGLEVEL 4
		#define BRNFEEDBACK
		#define CST cst

		#define BOID_RADIUS $radius
		#define BOID_SEPERATIONSFACTOR $separation
		#define BOID_COHESIONFACTOR $cohesion
		#define BOID_STEERLIMIT $steerlimit
		#define BOID_GRAVITATIONFACTOR $gravitation
		#define BOID_SPEED $speed" > config.click;
		
		dirname="$nodes""Knoten""$radius""Radius";
		run_sim.sh;
		if [ ! -e "$method" ]; then mkdir "$method"; fi
		if [ -e 1 ]; then mv 1 $method/$dirname; fi
		
		I=$(($I+1));
		radius=$(($radius+30));
	
	done
	
	nodes=$(($nodes+1));
	
	
done

exit 0
