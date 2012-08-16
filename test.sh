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
  LIMIT=35
fi

SIMULATOR=$SIMULATOR LATEX=$ENABLE_LATEX VALGRIND=$VALGRIND_PARAMS MODE=SIMULATION START=1 LIMIT=$LIMIT ./tools/testing/gen_test_pdf.sh

exit 0
