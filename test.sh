#!/bin/sh

rm -f testbed.pdf

if [ "x$VALGRIND" = "x" ]; then
  VALGRIND_PARAMS=0
else
  VALGRIND_PARAMS=$VALGRIND
fi

if [ "x$NOLATEX" = "x" ] ; then
    ENABLE_LATEX=0
else
    ENABLE_LATEX=1
fi


LATEX=$ENABLE_LATEX VALGRIND=$VALGRIND_PARAMS MODE=SIMULATION START=1 LIMIT=35 ./tools/testing/gen_test_pdf.sh

exit 0
