#!/bin/bash

# get des file
DES_FILE=`ls | grep *.des`

# get sim duration from *.des file
SIM_DUR=`cat $DES_FILE | grep "TIME" | sed 's#=# #g' | awk '{print $2}'`

# reduce SIM_DUR since the sim should run 1 sec longer, just for safety
let SIM_DUR=SIM_DUR-1

# gen *.ctl file by inserting real sim duration
cat flow.ctl.tmpl | sed "s#SIM_DUR#$SIM_DUR#g" > flow.ctl
