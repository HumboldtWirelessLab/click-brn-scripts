#!/bin/sh

rm -f testbed.pdf

if [ "x$VALGRIND" = "x" ]; then
  VALGRIND_PARAMS=0
else
  VALGRIND_PARAMS=$VALGRIND
fi 


VALGRIND=$VALGRIND_PARAMS MODE=SIMULATION START=1 LIMIT=35 ./tools/testing/gen_test_pdf.sh

exit 0
