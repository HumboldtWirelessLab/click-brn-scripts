#!/bin/sh

echo "<interference_experiment>"

if [ -e $1/interference_info.xml ]; then
    cat $1/interference_info.xml
fi


NODES=`(cd $1; ls ig_stats_post* | sed "s#\.# #g" | awk '{print $2}')`

seq=0;

for n in $NODES; do

  echo "<source node_a=\"$n\" node_b=\"none\" seq=\"$seq\" >"

  echo "<pre_flow id=\"1\" >"
  cat $1/ig_stats_pre.$n | human_readable.sh
  echo "</pre_flow>"

  echo "<during_flow id=\"2\" >"
  cat $1/ig_stats_dur.$n | human_readable.sh
  echo "</during_flow>"

  echo "<during_flow_stats id=\"3\" >"
  cat $1/ig_stats_dur_flow.$n | human_readable.sh
  echo "</during_flow_stats>"

  echo "<post_flow id=\"4\" >"
  cat $1/ig_stats_post.$n | human_readable.sh
  echo "</post_flow>"

  seq=`expr $seq + 1`

  echo "</source>"

done

echo "</interference_experiment>"
