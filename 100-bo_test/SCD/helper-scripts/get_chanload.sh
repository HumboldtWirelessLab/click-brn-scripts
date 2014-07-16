#!/bin/bash

LOAD=`cat 1/measurement.log | grep -m 1 hwbusy | sed "s#=# #g" | sed "s#\"# #g" | awk '{print $3}'`

echo $LOAD
