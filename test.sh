#!/bin/bash

rm -f testbed.pdf

if [ "x$VALGRIND" = "x" ]; then
  VALGRIND_PARAMS=0
else
  VALGRIND_PARAMS=$VALGRIND
fi

if [ "x$VALGRINDXML" = "x" ]; then
  VALGRINDXML_PARAMS=0
else
  VALGRINDXML_PARAMS=$VALGRIND
fi

if [ "x$NOLATEX" = "x1" ] ; then
    ENABLE_LATEX=0
else
    ENABLE_LATEX=1
fi

if [ "x$SIMULATOR" = "x" ]; then
  SIMULATOR=ns
fi

if [ "x$LIMIT" = "x" ]; then
  LIMIT=`ls -d 0* | tail -n 1 |awk -F- '{print $1}' | sed -e "s#^0*##g"`
fi

if [ "x$START" = "x" ]; then
  START=1
fi


NO_SIM=`echo $SIMULATOR | wc -w`

for next_sim in $SIMULATOR; do

  SIMULATOR=$next_sim LATEX=$ENABLE_LATEX VALGRIND=$VALGRIND_PARAMS VALGRINDXML=$VALGRINDXML_PARAMS MODE=SIMULATION START=$START LIMIT=$LIMIT ./tools/testing/gen_test_pdf.sh

  if [ -f testbed.pdf ] && [ $NO_SIM -gt 1 ]; then
    mv testbed.pdf testbed_$next_sim.pdf
  fi

done

exit 0
