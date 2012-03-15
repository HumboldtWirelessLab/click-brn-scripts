#!/bin/sh

for count in 20 30 40 50;
	do
	for simuRun in {1..1000};
		do
		for s in 65 75 85;
			do
			sizeCommand="sqrt(${count})*${s}"
			size=`echo ${sizeCommand} | bc`
			dir="scurow_${s}_${count}_${simuRun}"
			
			if [ "x$1" = "x" ]; then
				cat linkstat.mes.tmpl | sed "s#NODENUM#$count#g" > linkstat.mes
				cat linkstat.des.tmpl | sed "s#PARAMS_FIELDSIZE#$size#g"  > linkstat.des

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
	zip scurowMeasurements.zip scurow*
fi
