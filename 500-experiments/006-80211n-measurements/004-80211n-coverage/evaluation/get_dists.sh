#!/bin/sh


function mac_to_num() {
  NODEMAC_SEDARG=""
  
  if [ "x$1" != "x" ]; then
    while read line; do
      NODENAME=`echo $line | awk '{print $1}'`
      NODEMAC=`echo $line | awk '{print $3}'`
      NODENUM=`echo $line | awk '{print $4}'`
      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUM#g -e s#$NODENAME#$NODENUM#g"
    done < $1
  fi
  
  # echo $NODEMAC_SEDARG >&2
 
  sed $NODEMAC_SEDARG
}
					

NODES=`cat $1 | grep -v "#" | awk '{print $1}' | sort -u`

echo -n "" > node_dist.mat.tmp

for n in $NODES; do
  XN=`cat $1 | grep $n | awk '{print $2}'`
  YN=`cat $1 | grep $n | awk '{print $3}'`
  ZN=`cat $1 | grep $n | awk '{print $4}'`
  for m in $NODES; do
    if [ $n != $m ]; then
      XM=`cat $1 | grep $m | awk '{print $2}'`
      YM=`cat $1 | grep $m | awk '{print $3}'`
      ZM=`cat $1 | grep $m | awk '{print $4}'`
      
      XDIST=`calc "round(sqrt(($XN - $XM)*($XN - $XM)))" | awk '{print $1}'`
      YDIST=`calc "round(sqrt(($YN - $YM)*($YN - $YM)))" | awk '{print $1}'`
      ZDIST=`calc "round(sqrt(($ZN - $ZM)*($ZN - $ZM)))" | awk '{print $1}'`
      
      #echo "$XN  $XM $YN $YM $YN $YM $ZN $ZM $ZN $ZM"
      DIST=`calc "round(sqrt((($XN - $XM)*($XN - $XM) + ($YN - $YM)*($YN - $YM) + ($ZN - $ZM)*($ZN - $ZM))))" | awk '{print $1}'`
                  
      echo "$n $m $XDIST $YDIST $ZDIST $DIST" >> node_dist.mat.tmp 

    fi
  done
done

cat node_dist.mat.tmp | mac_to_num $2 >  node_dist.mat

rm -rf node_dist.mat.tmp
