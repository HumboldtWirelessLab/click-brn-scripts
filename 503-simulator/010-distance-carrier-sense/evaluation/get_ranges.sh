#!/bin/sh

M=`cat cs_range | awk '{print $2}' | sort -nu`
R=`cat cs_range | awk '{print $3}' | sort -nu`

declare -a radiomodels=('tworayground' 'shadowing' 'shadowing11b' 'tworayground01b' 'tworayground11b' 'tworayground54g');


for m in $M; do

  LAST_RX_RANGE=0;
  LAST_CS_RANGE=0;
  FIRST_NO_RX_RANGE=0;
  PREV_RANGE=0

  for r in $R; do
    CS=`cat cs_range | grep " $m $r " | awk '{print $4}'`
    RX=`cat rx_range | grep " $m $r " | awk '{print $4}'`

    if [ $RX -lt 95 ]; then
      if [ $LAST_RX_RANGE -eq 0 ]; then
        LAST_RX_RANGE=$PREV_RANGE
      fi
      if [ $FIRST_NO_RX_RANGE -eq 0 ]; then
        FIRST_NO_RX_RANGE=$r
      fi
    fi

    if [ $CS -lt 5 ]; then
      if [ $LAST_CS_RANGE -eq 0 ]; then
        LAST_CS_RANGE=$PREV_RANGE
      fi
    fi

    PREV_RANGE=$r

    #echo "$m $r $CS $RX"

  done

  let RXRANGE=10000*LAST_RX_RANGE/14142

  echo "MAXRXRANGE=$LAST_RX_RANGE" > ${radiomodels[$m]}
  echo "RXRANGE=$RXRANGE" >> ${radiomodels[$m]}
  echo "CSRANGE=$LAST_CS_RANGE" >> ${radiomodels[$m]}
  echo "NORXRANGE=$FIRST_NO_RX_RANGE" >> ${radiomodels[$m]}

done

exit 0

