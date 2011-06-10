#!/bin/sh
HOUSE=$1
FLOOR=$2
X=$3
Y=$4

XSTART=400
YSTART=0

XRATIO=`calc "15000 / 178" | sed 's#~##g' | awk '{print $1}'`
YRATIO=`calc "53000 / 580" | sed 's#~##g' | awk '{print $1}'`

YDIFF=`cat $0 | grep "#$1 $2" | awk '{print $3}'`
XDIFF=`cat $0 | grep "#$1 $2" | awk '{print $4}'`
XOFFSET=`cat $0 | grep "#$1 $2" | awk '{print $5}'`

XR=`expr $X - $XDIFF`
YR=`expr $Y - $YDIFF`

echo "$XR $YR"

XFIN=`calc "round(($XR * $XRATIO) / -10) + $XOFFSET" | awk '{print $1}'`
YFIN=`calc "round(($YR * $YRATIO) / 10)" | awk '{print $1}'`
ZFIN=`calc "100 - 350 * ( 4 - $FLOOR )" | awk '{print $1}'`

echo "$XFIN $YFIN $ZFIN"

#STARTS
#HOUSE FLOOR Y X OFFSET
#4 1 10 210 -2450
#4 2 10 410 -2450
#4 3 10 610 -2450
#4 4 10 810 -2450
#3 1 610 210 850
#3 2 610 410 850
#3 3 610 610 850
#3 4 610 810 850
#2 1 1250 210 4100 
#2 2 1250 410 4100
#2 3 1250 610 4100
#2 4 1250 810 4100
