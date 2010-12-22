#!/bin/sh

for n in `cat $1 | grep -v "#"`; do

COUNT=`cat $2/flooding_stats.$n | human_readable.sh | grep "<src addr=" | awk '{print $2}' | sed 's#addr="##g' | sed 's#"##g' | sort -u | wc -l`

if [ $COUNT -gt 1 ]; then
  #NODES=`cat $2/flooding_stats.$n | human_readable.sh | grep "<src addr=" | awk '{print $2}' | sed 's#addr="##g' | sed 's#"##g' | sort -u`
  echo "Error in flooding_stats.$n . Count: $COUNT"
  # Nodes: $NODES"
fi

CHANNEL_COUNT=`cat $2/flooding_stats.$n | human_readable.sh | grep "<phy" | awk '{print $8}' | sed 's#channel="##g' | sed 's#"##g' | sort -u | wc -l`

if [ $CHANNEL_COUNT -gt 1 ]; then
  echo "Channel Error in flooding_stats.$n . Count: $CHANNEL_COUNT"
fi

done

