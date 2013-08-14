#!/bin/sh

. $CONFIGFILE

rm -f $EVALUATIONSDIR/measurement.xml

if [ -f measurement.log.bz2 ]; then
  rm -f measurement.log;
fi

exit 0
