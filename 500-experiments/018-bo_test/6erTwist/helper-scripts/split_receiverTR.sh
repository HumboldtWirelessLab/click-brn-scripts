#!/bin/bash

NODE=0

if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

echo $FOO

bzcat $DIR/receiver.tr.bz2 | \
grep -v "tcp 0" | \
awk '{print $1,$2,$3,$10}' | \
sed 's#raw#data#g' | sed 's#tcp#data#g' | sed 's#D#COL#g' | \
awk '{
	if ($1 == "s" && $4 == "RTS") {
	   print "";
	}
	print $0;
}'
