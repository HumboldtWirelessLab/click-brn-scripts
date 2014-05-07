#!/bin/bash

#echo "Eval not valid"

#exit 0

. $CONFIGFILE

if [ ! -e $EVALUATIONSDIR ]; then
  mkdir -p $EVALUATIONSDIR
fi

THRESHOLD=10000

cat $RESULTDIR/measurement.log | grep "link from" | grep -v 'metric="9999"' | sed 's#"# #g' | awk '{print $3" "$5}' | sed -e "s#-##g" | sort -u > $EVALUATIONSDIR/links.all
cat $RESULTDIR/measurement.log | grep "link from" | grep -v 'metric="9999"' | sed 's#"# #g' | awk '{print $3" "$5" "$7}' | sed -e "s#-##g" | sort -u > $EVALUATIONSDIR/linksmetric.all

FULLSED=""
while read line; do
  SRCN=`echo $line | awk '{print $1}'` 
  SRCM=`echo $line | awk '{print $2}' | sed -e "s#-##g"`
  
  FULLSED="$FULLSED -e s#$SRCM#$SRCN#g"
done < $RESULTDIR/nodes.mac

#echo $FULLSED

echo "digraph G {" > $EVALUATIONSDIR/dhtring.dot.tmp

xsltproc dht_table.xslt $EVALUATIONSDIR/measurement.xml >> $EVALUATIONSDIR/dhtring.dot.tmp

echo "}" >> $EVALUATIONSDIR/dhtring.dot.tmp

cat $EVALUATIONSDIR/dhtring.dot.tmp | sed $FULLSED > $EVALUATIONSDIR/dhtring.dot
dot -Tpng $EVALUATIONSDIR/dhtring.dot > $EVALUATIONSDIR/dhtring.png
