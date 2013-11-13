#!/bin/sh

. $CONFIGFILE

if [ -f $RESULTDIR/measurement.log.bz2 ]; then 
  rm -f $RESULTDIR/measurement.log; 
  (cd $RESULTDIR; bzip2 -k -d measurement.log.bz2 )
fi

#rm -f $RESULTDIR/*.eth0

exit 0
