#!/bin/bash

if [ "x$1" == "x"  ]; then
	DIR="1"
else
	DIR=$1
fi

bzcat $DIR/receiver.tr.bz2 | grep -v "tcp 0" | sed "s#130.00#\tRX#g" | sed "s#260.00#\tTX2#g" | sed "s# 0.00#\tTX1#g" > rx.log; $EDITOR rx.log
