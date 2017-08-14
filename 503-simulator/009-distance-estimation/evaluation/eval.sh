#!/bin/sh

. $CONFIGFILE
. $RESULTDIR/../config

RECEIVER=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $1}' | head -n 1`
DEVICE=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $2}' | head -n 1`

if [ "x$VAR_RADIO" = "x" ]; then
  VAR_RADIO=0
fi

if [ "x$VAR_RXRANGE" = "x" ]; then
  VAR_RXRANGE=0
fi

if [ "x$VAR_FADING" = "x" ]; then
  VAR_FADING=0
fi

if [ "x$VAR_PL_EXP" = "x" ]; then
  VAR_PL_EXP=0
fi

if [ "x$VAR_STD_DB" = "x" ]; then
  VAR_STD_DB=0
fi

if [ "x$VAR_INIT_STD_DB" = "x" ]; then
  VAR_INIT_STD_DB=0
fi

if [ "x$VAR_RICEAN_MAXV" = "x" ]; then
  VAR_RICEAN_MAXV=0
fi

if [ "x$VAR_RICEAN_K" = "x" ]; then
  VAR_RICEAN_K=0
fi


if [ -f $RESULTDIR/$RECEIVER.$DEVICE.raw.dump ]; then
  CONF="$VAR_RADIO $VAR_RXRANGE $VAR_FADING $VAR_PL_EXP $VAR_STD_DB $VAR_INIT_STD_DB $VAR_RICEAN_MAXV $VAR_RICEAN_K"
  fromdump.sh $RESULTDIR/$RECEIVER.$DEVICE.raw.dump | awk -v CONF="$CONF" '{print CONF" "$2" "$3" "$5" "$6}' | sed -e "s#Mb##g" -e "s#/# #g" -e "s#:##g" -e "s#+##g" > $RESULTDIR/result.dat
  PACKETS=`cat $RESULTDIR/result.dat | wc -l`
else
  echo "No Dumpfile"
  PACKETS=0
fi

echo "$PACKETS packets received"
echo "PACKETS=$PACKETS" > $RESULTDIR/result

exit 0
