#!/bin/sh

if [ "x$1" = "x1" ]; then
NODECOUNT="20 30 40 50"
RUNS=1000
NODEDIST="65 75 85"
else
NODECOUNT="20"
RUNS=1
NODEDIST="65"
fi


for count in $NODECOUNT;
	do
	for simuRun in `seq $RUNS`;
		do
		for s in $NODEDIST;
			do
			dir="scurow_${s}_${count}_${simuRun}"
			
			if [ "x$1" = "x" ]; then
				cat linkstat.mes.tmpl | sed "s#NODENUM#$count#g" > linkstat.mes
				cat linkstat.des.tmpl | sed "s#PARAMS_FIELDSIZE#$s#g"  > linkstat.des

				run_sim.sh ns linkstat.des $dir
				rm -f linkstat.mes linkstat.des
			fi
			
			if [ "x$1" = "xtest" ]; then
				echo "running run_sim.sh ns linkstat.des ${dir}"
			fi
		done
	done
done

if [ "x$1" = "x" ]; then
	zip -r scurowMeasurements.zip scurow*
fi
