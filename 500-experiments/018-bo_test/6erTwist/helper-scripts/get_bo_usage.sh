#!/bin/bash

if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

echo "<document>" > xml.log
cat $DIR/measurement.log | grep "<" | grep -v "2hop" >> xml.log
echo "</document>" >> xml.log

xsltproc helper-scripts/bo_usage.xslt xml.log
