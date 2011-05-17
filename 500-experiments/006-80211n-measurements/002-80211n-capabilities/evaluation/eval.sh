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

DIRNUM=1

echo "INDEX RATEINDEX BANDWIDTH SGI GF FEC SHORTPREAMBLE STBC CHANNEL RX_ALL RX_OK RX_ERR" > $RESULTDIR/result.txt 

while [ -e $RESULTDIR/$DIRNUM ]; do

  if [ -f $RESULTDIR/$DIRNUM/params ]; then
    if [ ! -f $RESULTDIR/$DIRNUM/dump_raw.out ]; then
      if [ -f $RESULTDIR/$DIRNUM/wndr231.wlan0.raw.dump ]; then
        ( cd $RESULTDIR/$DIRNUM; WIFI=802 fromdump.sh wndr231.wlan0.raw.dump > dump_raw.out )
      else
        ( cd $RESULTDIR/$DIRNUM; WIFI=802 fromdump.sh wndr231.wlan1.raw.dump > dump_raw.out )
      fi
    fi
    RX_NUM=`cat $RESULTDIR/$DIRNUM/dump_raw.out | grep -e ":[[:space:]]*132[[:space:]]|" | egrep "13.0Mb|14.4Mb|27.0Mb|30.0Mb|65.0Mb|72.2Mb|135.0Mb|150.0Mb|130.0Mb|144.4Mb|270.0Mb|300.0Mb" | wc -l`
    RX_OK=`cat $RESULTDIR/$DIRNUM/dump_raw.out | grep -e ":[[:space:]]*132[[:space:]]|" | egrep "13.0Mb|14.4Mb|27.0Mb|30.0Mb|65.0Mb|72.2Mb|135.0Mb|150.0Mb|130.0Mb|144.4Mb|270.0Mb|300.0Mb" | grep OKPacket | grep -v err | wc -l`
    RX_ERR=`cat $RESULTDIR/$DIRNUM/dump_raw.out | grep -e ":[[:space:]]*132[[:space:]]|" | egrep "13.0Mb|14.4Mb|27.0Mb|30.0Mb|65.0Mb|72.2Mb|135.0Mb|150.0Mb|130.0Mb|144.4Mb|270.0Mb|300.0Mb" | grep err | wc -l`

    . $RESULTDIR/$DIRNUM/params

    echo "$DIRNUM $PARAMS_RATEINDEX $PARAMS_BANDWIDTH $PARAMS_SGI $PARAMS_GF $PARAMS_FEC $PARAMS_SHORTPREAMBLE $PARAMS_STBC $PARAMS_CHANNEL $RX_NUM $RX_OK $RX_ERR" >> $RESULTDIR/result.txt
  fi

  DIRNUM=`expr $DIRNUM + 1`
done

exit 0
