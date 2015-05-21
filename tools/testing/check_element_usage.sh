#!/bin/bash

if [ "x$MODE" = "xSIMULATION" ]; then
  GREPARG=`find $CLICKPATH/elements/brn -iname *.cc | grep -v "wifi/driver/" | grep -v "routing/aodv/" | grep -v "routing/olsr/" | xargs cat | grep EXPORT | sed "s#\(EXPORT_ELEMENT(\|)\|;\)##g" | tr '\n' '|'`
else
  GREPARG=`find $CLICKPATH/elements/brn -iname *.cc | xargs cat | grep EXPORT | sed "s#\(EXPORT_ELEMENT(\|)\|;\)##g" | tr '\n' '|'`
fi

GREPARG="\"$GREPARG-foo\""

if [ "x$MODE" = "xSIMULATION" ]; then
  SEDARG=`find $CLICKPATH/elements/brn -iname *.cc | grep -v "wifi/driver/" | grep -v "routing/aodv/" | grep -v "routing/olsr/" | xargs cat | grep EXPORT | sed "s#\(EXPORT_ELEMENT(\|)\|;\)##g" | tr '\n' '|' | sed "s#|#\\\\\\\\|#g"`
else
  SEDARG=`find $CLICKPATH/elements/brn -iname *.cc | xargs cat | grep EXPORT | sed "s#\(EXPORT_ELEMENT(\|)\|;\)##g" | tr '\n' '|' | sed "s#|#\\\\\\\\|#g"`
fi

SEDARG="s#\($SEDARG-foo\)# \1 #g"

#echo $SEDARG
#echo $GREPARG

if [ "x$FULLMEASUREMENT" != "x1" ]; then
  FILES=$1
else
  FILES=`(cd $1; cat \`ls *.mes.*\` | grep -v "#" | awk '{print $7}' | grep -v "^-$")`
  #echo $FILES
fi

(for i in $FILES; do cat $i; done)  | egrep $GREPARG | sed -e "$SEDARG" | tr ' ' '\n' | egrep $GREPARG | sort -u
