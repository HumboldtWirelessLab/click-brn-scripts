#!/bin/sh

. $CONFIGFILE

rm -f $EVALUATIONSDIR/measurement.xml

if [ -f $RESULTDIR/measurement.log.bz2 ]; then
  rm -f $RESULTDIR/measurement.log;
fi

exit 0
