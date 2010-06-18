#!/bin/sh

OK=""
FAILED=""

COK=0
CFAILED=0

for i in `ls .`; do
  if [ -f $i/FILES ]; then
    (cd $i; ns simple.tcl > output.log 2>&1)
    RETURN=$?
    
    if [ $RETURN -ne 0 ]; then
      FAILED="$FAILED $i"
      CFAILED=`expr $CFAILED + 1`
    else
      OK="$OK $i"
      COK=`expr $COK + 1`
    fi  
  fi
done

echo "OK ($COK): $OK"
echo "FAILED ($CFAILED): $FAILED"

exit 0
