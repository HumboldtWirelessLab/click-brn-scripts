#!/bin/sh

GPS_OPEN=`cat $2 | awk '{print NR" "$0}' | grep '<gps' | awk '{print $1}'`
CS_OPEN=`cat $1 | awk '{print NR" "$0}' | grep '<chann' | awk '{print $1}'`

GPS_LINES=`cat $2 | wc -l`
CS_LINES=`cat $1 | wc -l`

#echo "$GPS_OPEN"
#echo "$CS_OPEN"

GPS_OPEN_ARRAY=()
CS_OPEN_ARRAY=()

NUM=0

for i in $GPS_OPEN; do
  GPS_OPEN[$NUM]=$i
  NUM=`expr $NUM + 1`
done

GPS_OPEN[$NUM]=$GPS_LINES

NUM=0

for i in $CS_OPEN; do
  CS_OPEN[$NUM]=$i
  NUM=`expr $NUM + 1`
done
CS_OPEN[$NUM]=`expr $CS_LINES + 1`

NUM=`expr $NUM - 1`

#echo "0: ${GPS_OPEN[0]} 1: ${GPS_OPEN[1]}"
#echo "0: ${CS_OPEN[0]} 1: ${CS_OPEN[1]}"

GPSLINE_START=0
CSLINE_START=0

echo "<mobilemeasurement>"

for l in `seq 0 $NUM`; do
  GPSLINE_STOP=${GPS_OPEN[$l]}
  CSLINE_START=${CS_OPEN[$l]}
  l_next=`expr $l + 1`
  CSLINE_STOP=${CS_OPEN[$l_next]}
  
  
  GPS_TAIL_LINE=`expr $GPS_LINES - $GPSLINE_STOP + 1`
  GPS_HEAD_LINE=1
  
  CS_TAIL_LINE=`expr $CS_LINES - $CSLINE_START + 1`
  CS_HEAD_LINE=`expr $CSLINE_STOP - $CSLINE_START`

  echo "<mobilestats>"
  cat $2 | tail -n $GPS_TAIL_LINE | head -n $GPS_HEAD_LINE
  cat $1 | tail -n $CS_TAIL_LINE | head -n $CS_HEAD_LINE
  echo "</mobilestats>"
  
done

echo "</mobilemeasurement>"

