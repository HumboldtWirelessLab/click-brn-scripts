#!/bin/bash

while true; do

echo -n "check..."

for i in `find . -name .evaluation_done`; do
  DIR=`echo $i | sed "s#\.evaluation_done##g"`
  if [ -f $DIR/../nodes.mac ]; then
    echo $DIR
    rm $DIR/../*.*
  fi
  if [ -f $DIR/backoffusage.csv ]; then
    echo $DIR
    rm $DIR/*.csv
  fi

  mv $i $DIR/.evaluation_done.bak
done

echo "done"

sleep 120;

done
