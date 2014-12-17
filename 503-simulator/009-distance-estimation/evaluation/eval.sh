#!/bin/sh

. $CONFIGFILE
. $RESULTDIR/../config

RECEIVER=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $1}' | head -n 1`
DEVICE=`cat $NODETABLE | grep -v "#" | grep receiver.click | awk '{print $2}' | head -n 1`

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
