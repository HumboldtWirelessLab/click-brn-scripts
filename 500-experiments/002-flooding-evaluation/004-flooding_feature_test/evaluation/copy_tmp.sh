#!/bin/sh

. $CONFIGFILE

TMPFILECOUNT=`cat $NODETABLE | awk '{print $8}' | grep "/tmp/" | wc -l`

#echo $TMPFILECOUNT

echo -n "" > $NODETABLE.tmp

if [ $TMPFILECOUNT -ne 0 ]; then

  while read line; do
    NODE=`echo $line | awk '{print $1}'`
    FILE=`echo $line | awk '{print $8}'`

    NODELIST="$NODE" scp_node.sh $FILE $RESULTDIR

    echo $line | sed -e "s#/tmp/#$RESULTDIR/#g" >> $NODETABLE.tmp

  done < $NODETABLE

  mv $NODETABLE.tmp $NODETABLE

fi

exit 0
