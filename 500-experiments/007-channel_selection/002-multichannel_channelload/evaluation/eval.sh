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
    echo "Use: \"RESULTDIR=dir $0\" or \"$0 dir\""
    exit 0
  else
    RESULTDIR=$1
  fi
fi

SIGN=`echo $RESULTDIR | cut -b 1`

case "$SIGN" in
  "/")
	;;
  "~")
	;;
    *)
        RESULTDIR="$PWD/$RESULTDIR"
        ;;
esac

while read line; do
  NODENAME=`echo $line | awk '{print $1}'`
  NODEID=`echo $line | awk '{print $4}'`
  NODEMAC=`echo $line | awk '{print $3}'`
  NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$NODEMAC#$NODEID#g"
done < $RESULTDIR/nodes.mac

echo $NODEMAC_SEDARG

. $RESULTDIR/params

echo -n "" > $RESULTDIR/channelload.mat
echo -n "" > $RESULTDIR/neighbourstats.mat

for n in `cat $1/sender_and_receiver.mes.real | awk '{print $8}'` ; do

  echo "<channelstatsexp channel=\"$CHANNEL\" dev=\"$DEV\" num=\"$NUM\" rep=\"$REP\" >" > $RESULTDIR/result.xml
  
  FILENAME=`basename $n`
  cat $RESULTDIR/$FILENAME | grep "^[[:space:]]*<" >> $RESULTDIR/result.xml
    
  echo "</channelstatsexp>" >> $RESULTDIR/result.xml

  xsltproc $DIR/channelload.xslt $RESULTDIR/result.xml | sed $NODEMAC_SEDARG >> $RESULTDIR/channelload.mat

  xsltproc $DIR/neighbourstats.xslt $RESULTDIR/result.xml | sed $NODEMAC_SEDARG >> $RESULTDIR/neighbourstats.mat
  #> $RESULTDIR/$FILENAME.neighbourstats.xml

  rm -f $RESULTDIR/result.xml $RESULTDIR/$FILENAME.neighbourstats.xml
done
exit 0


