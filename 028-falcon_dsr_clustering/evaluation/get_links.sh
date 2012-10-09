#!/bin/bash

THRESHOLD=3000

cat $RESULTDIR/measurement.log | grep "<link from" | sed 's#"# #g' | awk '{print $3" "$5}' | sed -e "s#-##g" | sort -u > links.all
cat $RESULTDIR/measurement.log | grep "<link from" | sed 's#"# #g' | awk '{print $3" "$5" "$7}' | sed -e "s#-##g" | sort -u > linksmetric.all

NODES=`cat $RESULTDIR/measurement.log | grep "<link from" | sed 's#"# #g' | awk '{print $3}' | sed -e "s#-##g" | sort -u`

FULLSED=""

NONODE=1

for n in $NODES; do
  FULLSED="$FULLSED -e s#$n#$NONODE#g"
  NONODE=`expr $NONODE + 1`
done

#echo $NODES

#echo $FULLSED

echo "digraph G {" > linksmetric.dot.tmp
while read line; do
  SRC=`echo $line | awk '{print $1}'`
  DST=`echo $line | awk '{print $2}'`
    
  METRIC=`cat linksmetric.all | grep "$SRC $DST" | awk '{print $3}' | sort | head -n 1`
  
  if [ $METRIC -lt $THRESHOLD ]; then
    echo "\"$SRC\" -> \"$DST\"  [label=\"$METRIC\"];" >> linksmetric.dot.tmp
  fi
  
done < links.all

#echo "}" >> linksmetric.dot.tmp

echo "digraph G {" > links.dot.tmp
echo "digraph G {" > linksmetric.dot.tmp


for n in $NODES; do
  NUM=`echo $n | awk '{print strtonum("0x"$1)'}`
  NODENUM=`expr $NUM - 1`
  NODE=`cat $RESULTDIR/nodes.mac | grep " $NODENUM$" | awk '{print $1}'`
#  echo "$n $NUM $NODE"
  X=`cat $RESULTDIR/placementfile.plm | grep "$NODE " | awk '{print $2}'`
  X=`calc $X / 50 | sed "s#^[[:space:]]*~##g"`
  Y=`cat $RESULTDIR/placementfile.plm | grep "$NODE " | awk '{print $3}'`
  Y=`calc $Y / 50 | sed "s#^[[:space:]]*~##g"`
  echo "\"$n\" [pos=\"$X,$Y!\"];" >> links.dot.tmp
  echo "\"$n\" [pos=\"$X,$Y!\"];" >> linksmetric.dot.tmp
done

cat links.all | sort -u | awk '{print "\"" $1 "\" -> \"" $2 "\" [label=\"1\"];"}' >> links.dot.tmp
echo "}" >> links.dot.tmp

cat links.dot.tmp | sed $FULLSED > links.dot
#dot -Tpng links.dot > links.png
#neato -Tpng links.dot > links.png

neato -Teps links.dot > links.eps 2> /dev/null

if [ $? -ne 0 ]; then
  rm -f links.eps
  neato -Tpng links.dot > links.png 2> /dev/null
  if [ $? -ne 0 ]; then
    rm -f links.png
    echo "No Images"
  fi
fi

rm links.dot*

rm -f conn.mat

for n1 in $NODES; do
  for n2 in $NODES; do
    METRIC=`cat linksmetric.all | grep "$n1 $n2" | awk '{print $3}' | sort -n | head -n 1`
    if [ "x$METRIC" != "x" ]; then
      if [ $METRIC -lt $THRESHOLD ]; then
        echo "\"$n1\" -> \"$n2\" [label=\"$METRIC\"];" >> linksmetric.dot.tmp
      fi
    fi 
  
    if [ $n1 = $n2 ]; then
      EXISTS=1
    else
      EXISTS=`cat links.all | grep "$n1 $n2" | wc -l`
    fi
    
    if [ $EXISTS -gt 0 ]; then
      echo -n "1 " >> conn.mat
    else
      echo -n "0 " >> conn.mat
    fi
    
  done
  echo "" >> conn.mat
done

echo "}" >> linksmetric.dot.tmp

cat linksmetric.dot.tmp | sed $FULLSED > linksmetric.dot
#neato -Tpng linksmetric.dot > linksmetric.png
neato -Teps linksmetric.dot > linksmetric.eps 2> /dev/null

if [ $? -ne 0 ]; then
  rm -f linksmetric.eps
  neato -Tpng linksmetric.dot > linksmetric.png 2> /dev/null
  if [ $? -ne 0 ]; then
    rm -f linksmetric.png
  fi
fi


rm linksmetric.dot*
