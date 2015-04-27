#!/bin/bash
# Author: kuehne@informatik.hu-berlin.de
# Function: Stream-Test; Program checks if throughput passes threshold to be valid.
# Return:
#			exit 0: ok
#			exit 1:
#			exit 2: throughput too small

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

  if [ -f $RESULTDIR/$f ]; then
    pkt_recv=`fromdump.sh $RESULTDIR/$f | grep $SENDERMAC | wc -l`
  else
    pkt_recv=0
  fi

  echo -n "$NODEPRE ($SENDER ($SENDERMAC) -> $RECEIVER): "
  # eval pdr
  pdr=`expr $pkt_recv \* 100 / \( 100 \)`
  if [ $pdr -gt 50 ]; then
    echo "PDR seems okay (PDR=$pdr/100)."
    let OK=OK+1
  else
    echo "PDR too small (PDR=$pdr/100)."
  fi

  let OVERALL=OVERALL+1

done

echo -n "PDR-Test: $OK of $OVERALL are ok! "

if [ $OVERALL -eq $OK ]; then
  echo "Passed!"
  exit 0
else
  echo "Failed!"
  exit 2 
fi

