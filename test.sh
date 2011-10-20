#!/bin/sh

rm -f testbed.pdf

MODE=SIMULATION START=1 LIMIT=3 ./tools/testing/gen_test_pdf.sh

exit 0
