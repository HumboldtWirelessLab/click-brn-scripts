#!/bin/sh

. $CONFIGFILE

#rm -f $EVALUATIONSDIR/measurement.xml

#rm -f $EVALUATIONSDIR/flooding_info/floodingforwardstats.csv $EVALUATIONSDIR/flooding_info/floodingforwardstats.mat $EVALUATIONSDIR/flooding_info/floodingsmallstats.csv

rm $RESULTDIR/*.*

if [ -f $RESULTDIR/measurement.log.bz2 ]; then
  rm -f $RESULTDIR/measurement.log;
fi

#if [ -f $EVALUATIONSDIR/flooding_info/floodingsmallstats.mat ]; then
#   ( cd $EVALUATIONSDIR/flooding_info/; bzip2 -z -9 floodingsmallstats.mat )
#fi

exit 0
