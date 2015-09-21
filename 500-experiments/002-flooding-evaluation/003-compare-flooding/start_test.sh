#!/bin/sh

if [ "x$1" = "xlocal" ]; then
  SIM=1 DATARATE=1 LIMIT=1 GRID=1 CONFIG=./simsetrc_small_local NONODES=100 ./start.sh
else

  if [ "x$PLACEMENTFILE" = "x" ]; then
    SIM=1 DATARATE=1 LIMIT=1 GRID=1 CONFIG=$CONFIG ./start.sh
  else
    SIM=1 DATARATE=1 LIMIT=1 PLACEMENTFILE=$PLACEMENTFILE PLACEMENT=1 CONFIG=$CONFIG ./start.sh
  fi

fi
