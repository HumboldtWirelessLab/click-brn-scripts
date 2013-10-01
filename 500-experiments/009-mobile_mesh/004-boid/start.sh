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
nodesBefore=3;
maxnodes=6;
radIncrements=5;

method="$1";
nodeplm="cubic";

fieldSizePRE=750;
fieldSizePOST=750;

if [ -e "1" ]; then rm -rf "1"; fi
if [ -e "$1" ]; then rm -rf "$1"; fi
if [ -e "$method" ]; then rm -rf "$method"; fi

while [ "$nodes" -lt "$maxnodes" ]
do
	#initiale platzierung der knoten in der boid.plm generieren
	placement.sh $nodes $nodeplm 50 50;
	
	#laufvariable re-initialisieren
	I=0;
	
	#simulationsparameter re-initialisieren
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
		#define BOID_SPEED $speed 
				
		#define LINKPROBE_PERIOD 500
		#define LINKPROBE_TAU 25000
		#define DLINKPROBE_PROBES \"2 500\""> config.click;
		
		dirname="$nodes""Knoten""$radius""Radius";

		run_sim.sh;
		
		if [ ! -e "$method" ]; then mkdir "$method"; fi
		if [ -e 1 ]; then mv 1 $method/$dirname; fi
		
		mkdir $method/$dirname/MatLab;
		
		# mac-adressen umwandeln in zahlen
		cat $method/$dirname/measurement.xml | MAC2NUM=1 human_readable.sh $method/$dirname/nodes.mac > dummy;
		mv dummy $method/$dirname/measurement.xml;
		
		#generiere *.csv dateien
		xsltproc gpscoords.xsl $method/$dirname/measurement.xml > $method/$dirname/MatLab/gpscoords.csv;		
		#xsltproc gpsmap.xsl $method/$dirname/measurement.xml > $method/$dirname/MatLab/gpsmap.csv;
		#xsltproc channelstats.xsl $method/$dirname/measurement.xml > $method/$dirname/MatLab/channelstats.csv;
		xsltproc linktable.xsl $method/$dirname/measurement.xml > $method/$dirname/MatLab/linktables.csv;

		
		#matlab scripte konfigurieren
		#to be implemented
		sed -e s/"field = zeros($fieldSizePRE,$fieldSizePRE);"/"field = zeros($fieldSizePOST,$fieldSizePOST);"/g MatLab/Coverage.m > $method/$dirname/MatLab/Coverage.m;
		sed -e s/"knoten = $(($nodesBefore*$nodesBefore));"/"knoten = $(($nodes*$nodes));"/g MatLab/Distances.m > $method/$dirname/MatLab/Distances.m;
		
		#auswertung per matlab
		cd $method/$dirname/MatLab;
		matlab -nodisplay < Coverage.m;
		matlab -nodisplay < Distances.m;
		cd ../../../;
		
		
		#laufvariable incrementieren
		I=$(($I+1));
		
		#simulations-parameter verändern
		radius=$(($radius+30));
	
	done
	
	nodesBefore=$nodes;
	nodes=$(($nodes+1));
	
done

exit 0
