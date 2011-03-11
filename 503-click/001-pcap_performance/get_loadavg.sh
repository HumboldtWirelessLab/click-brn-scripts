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

CHECKFILE=$FINALRESULTDIR/loadavg.lock

case "$1" in
    "start")
      echo -n "" > $FINALRESULTDIR/loadavg.values 2> /dev/null
      rm -rf $CHECKFILE
      echo $$ > $CHECKFILE
      while [ -f $CHECKFILE ]; do
        sleep 55
	$DIR/evaluation/system/grabsysinfo.pl 2>/dev/null | xsltproc $DIR/systomat.xslt - >> $FINALRESULTDIR/loadavg.values
      done
      ;;
    "stop")
      if [ -f $CHECKFILE ]; then
        PIDD=`cat $CHECKFILE | head -n 1 | awk '{print $1}'`
	kill $PIDD
      fi 
      rm -rf $CHECKFILE
      ;;
      *)
      echo "Unknown option: > $1 <"
      ;;
esac

exit 0
