#!/bin/sh

if [ "x$1" = "x" ] || [ "x$2" = "x" ] || [ "x$3" = "x" ]; then
  echo "Use $0 config old_node new_node > new_config"
fi

cat $1 | sed "s#$2#$3#g"
