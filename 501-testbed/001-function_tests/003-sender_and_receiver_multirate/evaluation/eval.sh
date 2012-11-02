#!/bin/sh

. $CONFIGFILE

# Get dump-file
DUMP_FILES=`ls -1 "$RESULTDIR" | grep "raw.dump"`

OK=0
OVERALL=0

for f in $DUMP_FILES; do
  NODEPRE=`echo $f | awk -F . '{print $1}' | tr -d '[0-9]'`
  #echo $NODEPRE
  SENDER=`cat $NODETABLE | grep -e "^$NODEPRE" | grep "sender.click" |  awk '{ print $1; }'`
  RECEIVER=`cat $NODETABLE | grep -e "^$NODEPRE" | grep "receiver.click" |  awk '{ print $1; }'`

  #echo "$SENDER"

  SENDERMAC=`cat $RESULTDIR/nodes.mac | grep $SENDER | awk '{ print $3; }'`

  START=`fromdump.sh $RESULTDIR/$f | grep "OKPacket" | head -n 1 | sed -e "s#[\.,/,+]# #g" | awk '{print $2}'`

  if [ -f $RESULTDIR/$f ]; then
    # Extrahiere Rate und prüfen, ob sie sich veränedert
    # OKPacket: 1317835802.696444: 1492 |  1Mb +15/-95 | data nods FF-FF-FF-FF-FF-FF C4-3D-C7-90-CA-8D 00-00-00-00-00-00 seq: 315 [ ].
    result=`fromdump.sh $RESULTDIR/$f | grep $SENDERMAC | awk '{print $5}' | sort -u | wc -l`
    #fromdump.sh $RESULTDIR/$f | grep $SENDERMAC | awk '{print $5}' | sort -u

    echo -n "$NODEPRE: "
    if [ $result -ge 12 ]; then
      echo $result "different rates. ok!"
      let OK=OK+1
    else
      echo "FAIL: Expecting min 12 different rates. $result"
    fi
  fi

  let OVERALL=OVERALL+1

done

echo -n "Rate-Test: $OK of $OVERALL are ok! "

if [ $OVERALL -eq $OK ]; then
  echo "Passed!"
  exit 0
else
  echo "Failed!"
  exit 2 
fi

