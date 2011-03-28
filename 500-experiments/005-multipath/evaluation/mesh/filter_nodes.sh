#!/bin/sh

NODEMAC_FILE=$1

GREPARG=""
WANTED_LIST=" "

while read line; do
    NODENAME=`echo $line | awk '{print $1}'`
    NODEMAC=`echo $line | awk '{print $3}'`
    NODEID=`echo $line | awk '{print $4}'`

    NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODEID#g"
    NODENAME_SEDARG="$NODENAME_SEDARG -e s#$NODENAME#$NODEID#g"
    MACNAME_SEDARG="$MACNAME_SEDARG -e s#$NODEMAC#$NODENAME#g"

    if [ "x$GREPARG" = "x" ]; then
      GREPARG="^[0-9]*[[:space:]][0-9]*[[:space:]]$NODEID[[:space:]]$NODEID[[:space:]]"
    else
      GREPARG="$GREPARG|^[0-9]*[[:space:]][0-9]*[[:space:]]$NODEID[[:space:]]$NODEID[[:space:]]"
    fi

    WANTED=`echo $NODENAME | grep "$2" | wc -l`

    if [ $WANTED -gt 0 ]; then
      WANTED_LIST="$WANTED_LIST $NODEID "
    fi

done < $NODEMAC_FILE

for a in $WANTED_LIST; do
  for b in $WANTED_LIST; do
    GREPARG="$GREPARG|^[0-9]*[[:space:]][0-9]*[[:space:]]$a[[:space:]]$b[[:space:]]"
  done
done

#echo $WANTED_LIST
#echo $GREPARG

egrep $GREPARG

exit 0

while read line; do
    RECEIVER=`echo $line | awk '{print $3}'`
    SENDER=`echo $line | awk '{print $4}'`

    if [ "x$SENDER" = "x$RECEIVER" ]; then
      echo $line
    else
	ISWR=`echo "$WANTED_LIST" | grep " $RECEIVER " | wc -l`
	ISWS=`echo "$WANTED_LIST" | grep " $SENDER " | wc -l`
	if [ $ISWR -eq 1 ] && [ $ISWS -eq 1 ]; then
	  echo $line
	fi
    fi

done < $3
