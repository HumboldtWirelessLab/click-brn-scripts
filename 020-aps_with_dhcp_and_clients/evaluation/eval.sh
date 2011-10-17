#!/bin/sh

IS_CONFIGURED=`cat $RESULTDIR/measurement.log | grep "dhcp_request" | wc -l`

if [ $IS_CONFIGURED -gt 0 ]; then
  echo "Client is configured"
  exit 0
else
  echo "Client is not configure. TODO: more info about errors (assoc-failure,...??) !"
  exit 2
fi
