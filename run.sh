#!/bin/sh


for i in `ls .`; do
  if [ -f $i/FILES ]; then
      (cd $i; ns simple.tcl > output.log 2>&1)

      CODE=$?
      if [ $CODE -ne 0 ]; then
        echo "Simulation $i failed. Result: $CODE.";
      fi
  fi
done

exit 0
