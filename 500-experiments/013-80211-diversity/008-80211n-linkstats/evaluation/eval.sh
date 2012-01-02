#!/bin/sh

echo "<entries>" > all.xml

for i in `ls *.wlan0.log`; do
  cat $i | grep "<" | sed "s#80211n#n#g" >> all.xml
done

echo "</entries>" >> all.xml
