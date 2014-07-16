#!/bin/bash

cat *.des | grep "TIME" | sed 's#=# #g' | awk '{print $2}'
