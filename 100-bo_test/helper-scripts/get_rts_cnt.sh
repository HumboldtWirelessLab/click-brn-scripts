#!/bin/bash

if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

echo -n "00-00-00-00-00-02: "; bzcat $DIR/receiver.tr.bz2 | grep -v "tcp 0" | awk '{if ($1 == "s" && $3 == "1" && $10 == "RTS") print $0;}' | wc -l
echo -n "00-00-00-00-00-03: "; bzcat $DIR/receiver.tr.bz2 | grep -v "tcp 0" | awk '{if ($1 == "s" && $3 == "2" && $10 == "RTS") print $0;}' | wc -l

echo -n "00-00-00-00-00-04: "; bzcat $DIR/receiver.tr.bz2 | grep -v "tcp 0" | awk '{if ($1 == "s" && $3 == "3" && $10 == "RTS") print $0;}' | wc -l
echo -n "00-00-00-00-00-05: "; bzcat $DIR/receiver.tr.bz2 | grep -v "tcp 0" | awk '{if ($1 == "s" && $3 == "4" && $10 == "RTS") print $0;}' | wc -l
