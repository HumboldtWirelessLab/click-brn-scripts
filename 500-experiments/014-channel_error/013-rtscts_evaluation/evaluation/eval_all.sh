#!/bin/sh

NUM=1

while [ -e ../$NUM/ ]; do
#  (cd ../$NUM/; sh ./eval_again.sh)
  . ../$NUM/params
  echo -n "$PARAMS "
  cat ../$NUM/evaluation/stats

  let NUM=NUM+1
done

exit 0
