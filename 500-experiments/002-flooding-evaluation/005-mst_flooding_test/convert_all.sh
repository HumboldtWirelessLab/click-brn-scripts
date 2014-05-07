#! /bin/bash

for file in `find .`; do
	#echo -n "../../converter.o < ";
	#echo -n $file;
	#echo -n " > ../";
	#echo -n $file;
	#echo ";"
	../../converter.o < $file > ../$file;
	echo -n $file;
	echo " done";
done
