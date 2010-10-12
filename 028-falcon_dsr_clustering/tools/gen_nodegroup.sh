#!/bin/sh

for n in `seq $1 $2`; do
  echo "$3$n"
done
