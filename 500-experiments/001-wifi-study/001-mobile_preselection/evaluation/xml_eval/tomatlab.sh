#!/bin/sh

echo "<mobilemeasurement>" > mobilemeasurement.xml
cat channelstats.xml >> mobilemeasurement.xml
echo "</mobilemeasurement>" >> mobilemeasurement.xml

echo "<mobilegps>" > mobilegps.xml
cat gps.xml >> mobilegps.xml
echo "</mobilegps>" >> mobilegps.xml


xsltproc channelstats.xslt mobilemeasurement.xml | sed "s#,# #g" > mobilemeasurement.mat.tmp
xsltproc gps.xslt mobilegps.xml | sed "s#,# #g" > mobilegps.mat.tmp

sh ./mac2id.sh mobilemeasurement.mat.tmp

cat mobilemeasurement.mat.tmp | ./mac2id_replace.sh > mobilemeasurement.mat
cat mobilegps.mat.tmp | ./mac2id_replace.sh > mobilegps.mat

rm -rf mobilemeasurement.mat.tmp mobilegps.mat.tmp  mobilemeasurement.xml mobilegps.xml macs.dat
