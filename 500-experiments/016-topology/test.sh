#!/bin/sh
RESULTCODE=0
SUBS=`ls -1d ???-*`
for DIR in $SUBS
do
	echo "---------------[ $DIR ]-------------"
	cd ${DIR}
	rm -rf 1  
	USEPYTHON=1 PROGRESS=1 run_sim.sh
	
	RET=$?
	case "$RET" in
	   0)   ;;
	   1)   echo "Error: While running simulation"
			RESULTCODE=-1;;
	   *)	echo "ERROR: Invalid return code by run_sim.sh ($RET)"
			RESULTCODE=-1;;
	esac

	cd ..
done

if [ "$RESULTCODE" -ne 0 ]
then
	RESULT="Failed"
else
	RESULT="Success"
fi

echo ""
echo "=> Test Result: $RESULT"
exit $RESULTCODE

