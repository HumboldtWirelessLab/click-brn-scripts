#!/bin/bash

if [ "x$1" = "x" ]; then
  echo "Use $0 e2e|simple|unic"
  exit 0
fi

MAINCONFIG=config/main.conf

case "$1" in
  "e2e")
    CONFIG=config/sim_e2e.conf
    ;;
  "simple")
    CONFIG=config/sim_simple.conf
    ;;
  "unicast")
    CONFIG=config/sim_unicast.conf
    ;;
  *)
    echo "Unknown option: $1"
    exit 0
    ;;
esac

CONFIG=$CONFIG MAINCONFIG=$MAINCONFIG ./start.sh

(cd evaluation; ./eval_all.sh ..)

(cd evaluation; mv result_flooding.dat result_flooding.dat.$1; mv result_flooding_info.dat result_flooding_info.dat.$1)

exit 0
