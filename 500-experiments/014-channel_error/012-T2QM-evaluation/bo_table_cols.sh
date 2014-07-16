#!/bin/bash

TABLE_FILE="bo_table"

if [ -e $TABLE_FILE ]; then
    rm $TABLE_FILE
fi

WIFIDEVPATH="/home/frank/2Work/Hwl/brn-tools/helper/measurement/etc/click/device"


#NO_SENDERS=`seq $SENDERS_LB $SENDERS_UP`
#NO_SENDERS="2 4 6 8 10 12 14 16 18 20 22 24 26 28 30"
NO_SENDERS="2 4"


#BACKOFFS=`seq $BO_LB $BO_UP`
#BACKOFFS="1 3 7 15 31 63 127 255 511 1023"

#BACKOFFS_EXP="2 3 4 5 6 7 8 9 10"
BACKOFFS_EXP="3 5 10"


echo ""

for sender in $NO_SENDERS; do
    echo "$sender                          "

    LEAST_COLS=99999
    BEST_CWMIN=0
    LOAD=0
    TP=0

    cat run.tmpl.sh | sed "s#SENDERS#\"$sender\"#g" > run_botable.sh

    for exp in $BACKOFFS_EXP; do

        let CWMIN=2**$exp-1
        let exp=exp+5
        let CWMAX=2**$exp-1

        echo "  $CWMIN                     "

        cat rawwifidev.click.tmpl | sed "s#CONST_BO#$CWMIN#g" > rawwifidev.click
        mv rawwifidev.click $WIFIDEVPATH

        cat monitor.tmpl | sed "s#BO_MIN#$CWMIN#g" | sed "s#BO_MAX#$CWMAX#g" > monitor

        rm -rf 1/; SIM=1 sh run_botable.sh;

        COLS=`sh helper-scripts/get_cols.sh`
        #echo "current cols: $COLS  current least cols: $LEAST_COLS"

        if [ $COLS -le $LEAST_COLS ]; then
            LEAST_COLS=$COLS
            BEST_CWMIN=$CWMIN
            LOAD=`sh helper-scripts/get_chanload.sh`
            TP=`sh helper-scripts/get_tp.sh`
            echo "new least cols: $LEAST_COLS bo: $BEST_CWMIN"
        fi
    done

    echo ">> writing sender: $sender least cols: $LEAST_COLS best bo: $BEST_CWMIN to table"
    echo ""
    echo "$sender $TP $BEST_CWMIN $LOAD $LEAST_COLS" >> bo_table
done

