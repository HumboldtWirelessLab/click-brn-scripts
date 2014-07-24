#!/bin/sh

#. $CONFIGFILE

#echo "$RESULTDIR/$NAME.tr"

if [ -f $RESULTDIR/$NAME.tr ]; then

  cat $RESULTDIR/$NAME.tr | grep -e "^s " | awk '{print $2" "$3" "$4" "$5" "$11}' > $RESULTDIR/txtrace.txt

fi

exit 0
