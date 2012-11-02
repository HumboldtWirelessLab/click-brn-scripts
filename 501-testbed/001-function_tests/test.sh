#!/bin/sh

rm -f testbed.pdf

if [ "x$VALGRIND" = "x" ]; then
  VALGRIND_PARAMS=0
else
  VALGRIND_PARAMS=$VALGRIND
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
  LIMIT=3
fi

if [ "x$START" = "x" ]; then
  START=1
fi

LATEX=$ENABLE_LATEX VALGRIND=$VALGRIND_PARAMS MODE=MEASUREMENT START=$START LIMIT=$LIMIT ../../tools/testing/gen_test_pdf.sh

exit 0
