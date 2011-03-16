echo "batch mode"
echo "processing dirs $@"

for dir in "$@"
do
	echo "processing dir $dir"
	cd $dir 

	echo "preparing"

	# create symbolic links
	ln -s sk110.log sk110.ath0.log 2> /dev/null
	ln -s sk110.log sk110.ath1.log 2> /dev/null

	ln -s sk111.log sk111.ath0.log 2> /dev/null
	ln -s sk111.log sk111.ath1.log 2> /dev/null

	ln -s sk112.log sk112.ath0.log 2> /dev/null
	ln -s sk112.log sk112.ath1.log 2> /dev/null

	mv localhost.ath0.log localhost2.ath0.log 2> /dev/null
	mv localhost.ath0.dump localhost2.ath0.dump 2> /dev/null

	files=`ls -l *.log | awk '{ print $8 }' | grep 'ath' | sort -u -r`
	echo "update sync file ... "
	echo "total: $files"

	echo "" > sync.dat
	for file in $files
	do
		 echo "update sync for $file"
		 nodeid=`echo $file | sed -s 's/[a-z]//g' | sed -s 's/\./\t/g'`
		 #echo "nodeid $nodeid"
		 grep -P "Sync:" $file | head -n15 | awk -v nodeid="$nodeid" '{ print nodeid "\t" $2 "\t" $5}' | awk --non-decimal-data '{print $1 "\t" $2 "\t" $3 "\t" ("0x"$4)+0 }' | sed -s 's/://g' >> sync.dat
	done
	cd ..


	echo "update dat files ... "
	files=`cd $dir; ls -l *.dump | awk '{ print $8 }'`
	echo "total: $files"

	for file in $files
	do
		 echo "generate matlab data for $dir/$file"
		./tomatlab.sh $dir $file
	done
done

