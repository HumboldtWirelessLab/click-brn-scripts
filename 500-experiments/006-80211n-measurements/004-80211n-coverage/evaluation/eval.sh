#!/bin/sh

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
  "/")
        DIR=$dir
	;;
  ".")
        DIR=$pwd/$dir
        ;;
    *)
        echo "Error while getting directory"
        exit -1
        ;;
esac

if [ "x$RESULTDIR" = "x" ]; then
  if [ "x$1" = "x" ]; then
    RESULTDIR=$DIR/../
  else
    RESULTDIR=$1
    SIGN=`echo $RESULTDIR | cut -b 1`

    case "$SIGN" in
      "/")
         ;;
       *)
         RESULTDIR="$PWD/$RESULTDIR"
         ;;
    esac
  fi
fi

function mac_to_num() {

  if [ "x$1" != "x" ]; then
    while read line; do
      NODENAME=`echo $line | awk '{print $1}'`
      NODEMAC=`echo $line | awk '{print $3}'`
      NODENUM=`echo $line | awk '{print $4}'`
      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUMg -e s#$NODENAME#$NODENUMg"
    done < $FILE
  fi

  sed $NODEMAC_SEDARG

}

DIRNUM=1

echo "TIME SIZE SRC DST STATE RATE HT RATEINDEX HT40 SGI SEQ NOISE RSSI" > $RESULTDIR/result.txt 

while [ -e $RESULTDIR/$DIRNUM ]; do

  if [ -f $RESULTDIR/$DIRNUM/params ]; then
    
    NODES=`cat $RESULTDIR/$DIRNUM/nodes.mac | awk '{print $1}'`
  
    for n in $NODES; do
    
      DEVICES=`cat $RESULTDIR/$DIRNUM/nodes.mac | grep "$n " | awk '{print $2}'`    
    
      for d in $DEVICES; do
      
        if [ ! -f $RESULTDIR/$DIRNUM/$n.$d.raw.out ]; then
        
	  if [ -f $RESULTDIR/$DIRNUM/$n.$d.raw.dump ]; then
            ( cd $RESULTDIR/$DIRNUM; WIFI=802 fromdump.sh $n.$d.raw.dump | grep "OKPack" | grep -v "err" | grep 1032 | grep FF-FF-FF-FF-FF-FF | sed -e "s#Mb##g" -e "s#+##g" -e "s#/# #g" > $n.$d.raw.out )
          else
	    echo "Missing Dump for $n $d"
          fi
	fi
	
	cat $n.$d.raw.dump | awk -v NODE=$n {print $2" "$3" "$16" "NODE" 1 "$5" "$6" "$7" "$8" "$9" "$10" "$11 } >> $RESULTDIR/result_$DIRNUM\.txt
    fi

  fi

  DIRNUM=`expr $DIRNUM + 1`
done

exit 0
