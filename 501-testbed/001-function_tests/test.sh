#!/bin/sh

rm -f testbed.pdf

MODE=MEASUREMENT START=1 LIMIT=2 ../../tools/testing/gen_test_pdf.sh

exit 0
