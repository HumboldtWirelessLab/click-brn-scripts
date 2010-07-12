#!/bin/bash

THRESHOLD=10000

cat $1 | grep "\-00 00\-0F" | awk '{print $1" "$2}' | sed -e "s#-##g" | sort -u > links.all
#cat $1 | grep "\-00 00\-0F" | awk '{print $1" "$2" "$3}' | sed -e "s#-##g" | sort -u > linksmetric.all

NODES=`cat $1 | grep "\-00 00\-0F" | awk '{print $1}' | sed -e "s#-##g" | sort -u`

FULLSED=""

NONODE=1

for n in $NODES; do
  FULLSED="$FULLSED -e s#$n#$NONODE#g"
  NONODE=`expr $NONODE + 1`
done

#echo $FULLSED

#echo "digraph G {" > linksmetric.dot.tmp
#while read line; do
#  SRC=`echo $line | awk '{print $1}'`
#  DST=`echo $line | awk '{print $2}'`
    
#  METRIC=`cat linksmetric.all | grep "$SRC $DST" | awk '{print $3}' | sort | head -n 1`
  
#  if [ $METRIC -lt $THRESHOLD ]; then
#    echo "\"$SRC\" -> \"$DST\"  [label=\"$METRIC\"];" >> linksmetric.dot.tmp
#  fi
  
#done < links.all

#echo "}" >> linksmetric.dot.tmp

#cat linksmetric.dot.tmp | sed $FULLSED > linksmetric.dot
#dot -Tpng linksmetric.dot > linksmetric.png

echo "digraph G {" > links.dot.tmp

cat links.all | sort -u | awk '{print "\"" $1 "\" -> \"" $2 "\" [label=\"1\"];"}' >> links.dot.tmp
echo "}" >> links.dot.tmp

cat links.dot.tmp | sed $FULLSED > links.dot
dot -Tpng links.dot > links.png

rm links.dot*

rm -f conn.mat

for n1 in $NODES; do
  for n2 in $NODES; do
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


