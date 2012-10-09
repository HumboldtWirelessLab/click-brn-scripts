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

echo "digraph G {" > $EVALUATIONSDIR/linksmetric.dot.tmp
while read line; do
  SRC=`echo $line | awk '{print $1}'`
  DST=`echo $line | awk '{print $2}'`
    
  METRIC=`cat linksmetric.all | grep "$SRC $DST" | awk '{print $3}' | sort | head -n 1`
  
  if [ $METRIC -lt $THRESHOLD ]; then
    echo "\"$SRC\" -> \"$DST\"  [label=\"$METRIC\"];" >> $EVALUATIONSDIR/linksmetric.dot.tmp
  fi
  
done < links.all

echo "}" >> $EVALUATIONSDIR/linksmetric.dot.tmp

cat $EVALUATIONSDIR/linksmetric.dot.tmp | sed $FULLSED > $EVALUATIONSDIR/linksmetric.dot
#dot -Tpng $EVALUATIONSDIR/linksmetric.dot > $EVALUATIONSDIR/linksmetric.png
dot -Teps $EVALUATIONSDIR/linksmetric.dot > $EVALUATIONSDIR/linksmetric.eps 2> /dev/null

if [ $? -ne 0 ]; then
  rm -f $EVALUATIONSDIR/linksmetric.eps
  dot -Tpng $EVALUATIONSDIR/linksmetric.dot > $EVALUATIONSDIR/linksmetric.png 2> /dev/null
  if [ $? -ne 0 ]; then
    rm -f $EVALUATIONSDIR/linksmetric.png
    echo "No image (png and eps not supported by dot!)!"
  fi
fi


echo "digraph G {" > $EVALUATIONSDIR/links.dot.tmp

cat links.all | sort -u | awk '{print "\"" $1 "\" -> \"" $2 "\" [label=\"1\"];"}' >> $EVALUATIONSDIR/links.dot.tmp
echo "}" >> $EVALUATIONSDIR/links.dot.tmp

cat $EVALUATIONSDIR/links.dot.tmp | sed $FULLSED > $EVALUATIONSDIR/links.dot
#dot -Tpng $EVALUATIONSDIR/links.dot > $EVALUATIONSDIR/links.png
dot -Teps $EVALUATIONSDIR/links.dot > $EVALUATIONSDIR/links.eps 2> /dev/null

if [ $? -ne 0 ]; then
  rm -f $EVALUATIONSDIR/links.eps
  dot -Tpng $EVALUATIONSDIR/links.dot > $EVALUATIONSDIR/links.png 2> /dev/null
  if [ $? -ne 0 ]; then
    rm -f $EVALUATIONSDIR/links.png
  fi
fi
