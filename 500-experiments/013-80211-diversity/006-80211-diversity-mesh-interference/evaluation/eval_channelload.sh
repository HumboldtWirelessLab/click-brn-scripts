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
  NODEMAC_SEDARG=""

  if [ "x$1" != "x" ]; then
    while read line; do
      NODENAME=`echo $line | awk '{print $1}'`
      NODEMAC=`echo $line | awk '{print $3}'`
      NODENUM=`echo $line | awk '{print $4}'`
      if [ "x$2" != "x" ]; then
        NODENUM=`cat $2 | grep $NODENAME | awk '{print $2}'`
      fi
      NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODENUM#g -e s#$NODENAME#$NODENUM#g"
    done < $1
  fi

# echo $NODEMAC_SEDARG >&2

  sed $NODEMAC_SEDARG
}

DIRNUM=1


echo "measurement node time mac_rx(packets) mac_busy(percent) mac_rx(perc) hwbusy hwrx channel" > channeload_head.txt

echo -n "" > $RESULTDIR/channelload.csv

while [ -e $RESULTDIR/$DIRNUM ]; do

  echo -n "$DIRNUM:"

  for i in `(cd $RESULTDIR/$DIRNUM; ls *wlan*.log)`; do
#    echo $RESULTDIR/$DIRNUM/$i
    echo "<measurement>" > $RESULTDIR/$DIRNUM/$i.xml
    cat $RESULTDIR/$DIRNUM/$i | grep -e "^[[:space:]]*<" >> $RESULTDIR/$DIRNUM/$i.xml
    echo "</measurement>" >> $RESULTDIR/$DIRNUM/$i.xml
    xsltproc $DIR/channelstats.xslt $RESULTDIR/$DIRNUM/$i.xml | mac_to_num $RESULTDIR/1/nodes.mac $2 | awk -v MNUM=$DIRNUM '{print MNUM","$0}' | head -n 3 >> $RESULTDIR/channelload.csv
  done 

  DIRNUM=`expr $DIRNUM + 1`

done

cat $RESULTDIR/channelload.csv | sed "s#,# #g" > $RESULTDIR/channelload.mat

exit 0
