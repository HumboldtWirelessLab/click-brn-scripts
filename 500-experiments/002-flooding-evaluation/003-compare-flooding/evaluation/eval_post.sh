#!/bin/sh

. $CONFIGFILE

if [ -e $EVALUATIONSDIR ]; then
   ( cd $EVALUATIONSDIR/; find -name *.csv | xargs rm -f )
fi

#rm -f $EVALUATIONSDIR/measurement.xml

#RESULT=`awk '{print $3}' $RESULTDIR/evaluation/flooding_info/floodingstats.mat`

#if [ "x$RESULT" = "x1" ]; then
#  rm $RESULTDIR/*.*
#fi

#if [ -f $RESULTDIR/measurement.log.bz2 ]; then
#  rm -f $RESULTDIR/measurement.log;
#fi

#if [ -f $EVALUATIONSDIR/flooding_info/floodingsmallstats.mat ]; then
#   ( cd $EVALUATIONSDIR/flooding_info/; bzip2 -z -9 floodingsmallstats.mat )
#fi

if [ -f $EVALUATIONSDIR/flooding_info/floodingforwardstats.mat ]; then
   ( cd $EVALUATIONSDIR/flooding_info/; bzip2 -z -9 floodingforwardstats.mat )
fi

if [ -f $EVALUATIONSDIR/measurement.xml ]; then
   ( cd $EVALUATIONSDIR/; bzip2 -z -9 measurement.xml )
fi


exit 0
