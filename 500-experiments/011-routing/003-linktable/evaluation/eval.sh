#!/bin/sh

GOOD_LINKS=`cat $RESULTDIR/measurement.log | grep "<link from=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $3" "$5" "$7}' | sort -u | awk '{print $3}' | grep -e "[0-9][0-9][0-9]" | wc -l`
#cat $RESULTDIR/measurement.log | grep "<link from=" | sed 's#"# #g' | sed "s#=# #g" | awk '{print $3" "$5" "$7}'

echo -n "$GOOD_LINKS good links."

if [ $GOOD_LINKS -ge 64 ]; then
  echo " OK !"
  exit 0
else
  echo " Too bad !"
  exit 2
fi
