#!/bin/bash

RESULT_PATH="input_dataset.xml"

echo "Cleaning script"

ls -d [0-9]*
ls "${RESULT_PATH}" 2>/dev/null

read -p "All files files will be removed..... (Ctrl-C to abort)" 

rm -rf [0-9]* ${RESULT_PATH}
