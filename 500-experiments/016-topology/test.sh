#!/bin/sh
RESULT=0
SUBS=`ls -1d ???-*`
for DIR in $SUBS
do
	echo "---------------[ $DIR ]-------------"
	cd ${DIR}
	rm -rf 1  
	run_sim.sh
	if [ $? -ne 0 ]
	then
		RESULT=-1
	fi
	cd ..
done

echo ""
echo "=> Test Result: $RESULT"
exit $RESULT

