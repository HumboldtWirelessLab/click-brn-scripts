#!/bin/bash

dirname="";

#laufvariable
I=0;

#initiale steuerungsfaktoren
radius=60;
separation=10000;
cohesion=-20;
steerlimit=10000;
gravitation=1000000;
speed=4;

probe_period=200;
probe_tau=4000;

gravitationXInit=400;
gravitationYInit=400;
gravitationX=400;
gravitationY=400;

plmStartX=50;
plmStartY=50;


#stellschräubchen für die simulationen
nodes=3;
maxnodes=6;
radIncrements=3;

method="$1";
nodeplm="cubic";

fieldSize=750;
fieldSizeInit=750;

# check for existing folders
if [ -e "1" ]; then rm -rf "1"; fi
if [ -e "$1" ]; then rm -rf "$1"; fi
if [ -e "$method" ]; then rm -rf "$method"; fi


while [ "$nodes" -lt "$maxnodes" ]
do
	#initiale platzierung der knoten in der boid.plm generieren
	placement.sh $nodes $nodeplm $plmStartX $plmStartY;
	
	#laufvariable re-initialisieren
	I=0;
	
	#simulationsparameter re-initialisieren
	radius=60;
	
	
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
				
		#define LINKPROBE_PERIOD $probe_period
		#define LINKPROBE_TAU $probe_tau
		#define DLINKPROBE_PROBES \"2 500\""> config.click;
		
		
		
		dirname="$nodes""Knoten""$radius""Radius";
		
		sed -i s/"write boid.gravitation add $gravitationXInit $gravitationYInit 0 2000000,"/"write boid.gravitation add $gravitationX $gravitationY 0 2000000,"/g boid.click;
		sed -i s/"FIELDSIZE=$fieldSizeInit"/"FIELDSIZE=$fieldSize"/g boid.des;
		
		run_sim.sh;
		
		sed -i s/"FIELDSIZE=$fieldSize"/"FIELDSIZE=$fieldSizeInit"/g boid.des;
		sed -i s/"write boid.gravitation add $gravitationX $gravitationY 0 2000000,"/"write boid.gravitation add $gravitationXInit $gravitationYInit 0 2000000,"/g boid.click;
		
		if [ ! -e "$method" ]; then mkdir "$method"; fi
		if [ -e 1 ]; then mv 1 $method/$dirname; fi
		
		mkdir $method/$dirname/MatLab;
		
		# mac-adressen umwandeln in zahlen
		cat $method/$dirname/measurement.xml | MAC2NUM=1 human_readable.sh $method/$dirname/nodes.mac > dummy;
		mv dummy $method/$dirname/measurement.xml;
		
		#generiere *.csv dateien
		xsltproc XSLT/gpscoords.xsl $method/$dirname/measurement.xml > $method/$dirname/MatLab/gpscoords.csv;		
		#xsltproc XSLT/channelstats.xsl $method/$dirname/measurement.xml > $method/$dirname/MatLab/channelstats.csv;
		xsltproc XSLT/linktable.xsl $method/$dirname/measurement.xml > $method/$dirname/MatLab/linktables.csv;

		
		#matlab scripte konfigurieren
		sed -e s/"gravitation = \[400,400\];"/"gravitation = \[$gravitationX,$gravitationY\];"/g -e s/"knoten = 9;"/"knoten = $(($nodes*$nodes));"/g -e s/"zeros($fieldSizeInit,$fieldSizeInit);"/"zeros($fieldSize,$fieldSize);"/g MatLab/Coverage.m > $method/$dirname/MatLab/Coverage.m;
		sed -e s/"knoten = 9;"/"knoten = $(($nodes*$nodes));"/g MatLab/Distances.m > $method/$dirname/MatLab/Distances.m;
		
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
	
	nodes=$(($nodes+1));
	fieldSize=$(($fieldSize+250));
	
	gravitationX=$(($gravitationX+100));
	gravitationY=$(($gravitationY+100));
	
	plmStartX=$(($plmStartX+25));
	plmStartY=$(($plmStartY+25));
	
done

exit 0
