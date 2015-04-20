#!/bin/sh

. $CONFIGFILE

# Get dump-file
DUMP_FILES=`ls -1 "$RESULTDIR" | grep "raw.dump"`

OK=0
OVERALL=0

for f in $DUMP_FILES; do
  NODENAME=`echo $f | awk -F . '{print $1}'`
  NODEPRE=`echo $f | awk -F . '{print $1}' | tr -d '[0-9]'`
  #echo $NODEPRE
  SENDER=`cat $NODETABLE | grep -e "^$NODEPRE" | grep "sender.click" |  awk '{ print $1; }'`
  RECEIVER=`cat $NODETABLE | grep -e "^$NODENAME" | grep "receiver.click" |  awk '{ print $1; }'`

  #echo "$SENDER"

  SENDERMAC=`cat $RESULTDIR/nodes.mac | grep $SENDER | awk '{ print $3; }'`

  START=`fromdump.sh $RESULTDIR/$f | grep "OKPacket" | head -n 1 | sed -e "s#[\.,/,+]# #g" | awk '{print $2}'`
  #echo $START

  fromdump.sh $RESULTDIR/$f | grep $SENDERMAC | sed -e "s#[\.,/,+]# #g" | awk -v S=$START '{print $2-S" "$7" "$16}' > $RESULTDIR/$RECEIVER.rssi.log

  for i in `seq 3`; do
    if [ -f $RESULTDIR/$f ]; then
      #fromdump.sh $RESULTDIR/$f | grep $SENDERMAC | sed -e "s#[\.,/,+]# #g" | awk -v S=$START '{print $2-S+10" "$7}'
      RSSI[$i]=`fromdump.sh $RESULTDIR/$f | grep $SENDERMAC | sed -e "s#[\.,/,+]# #g" | awk -v S=$START '{print $2-S+10" "$7}' | grep -e "^$i" | awk '{x+=$2; y+=1} END {print x/y}' | awk -F . '{print $1}'`
    else
      RSSI[$i]=0
    fi
    echo "$i "${RSSI[$i]}
  done

  echo -n "$NODEPRE: "
  if [ ${RSSI[1]} -gt ${RSSI[2]} ] && [ ${RSSI[2]} -gt ${RSSI[3]} ]; then
    echo "RSSI ok: ${RSSI[1]} > ${RSSI[2]} > ${RSSI[3]}."
    let OK=OK+1
  else
    echo "RSSI mistake: ${RSSI[1]}, ${RSSI[2]}, ${RSSI[3]}."
  fi

  let OVERALL=OVERALL+1

done

echo -n "RSSI-Test: $OK of $OVERALL are ok! "

if [ $OVERALL -eq $OK ]; then
  echo "Passed!"
  exit 0
else
  echo "Failed!"
  exit 2
fi

