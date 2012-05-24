#!/bin/bash


if [ "x$1" = "x" ]; then
  echo "Use $0 dir"
fi

ZIPDIR=zip_$RANDOM

mkdir -p $ZIPDIR
mkdir -p $ZIPDIR/$1

COUNT=1

while [ -e $1/$COUNT ]; do

  mkdir -p $ZIPDIR/$1/$COUNT
  cp $1/$COUNT/wndr*.dump $ZIPDIR/$1/$COUNT

  let COUNT=$COUNT+1

done

( cd $ZIPDIR/; tar cvfj ../$1.tar.bz2 $1 > ../$1.zip_log )

rm -rf $ZIPDIR
