#!/bin/bash

dir=$(dirname "$0")
pwd=$(pwd)

SIGN=`echo $dir | cut -b 1`

case "$SIGN" in
  "/")
      DIR=$dir
      ;;
  ".")
      DIR=$pwd/$dir
      ;;
   *)
      echo "Error while getting directory"
      exit -1
      ;;
esac

case "$1" in
    start)
        echo "Start ctl"
        CTLTIME=0
        while read line; do
          SIGN=`echo $line | cut -b 1`

          if [ "x$SIGN" != "x#" ]; then

            NEXTTIME=`echo $line | awk '{print $1}'`
            NODES=`echo $line | awk '{print $2}'`
            case "$NODES" in
               "ALL")
                   NODES=`cat $FINALRESULTDIR/nodes.mac | awk '{print $1}'`
                   ;;
               "LASTNODE")
                   NODES=`cat $FINALRESULTDIR/nodes.mac | awk '{print $1}' | tail -n 1`
                   ;;
               "FIRSTNODE")
                   NODES=`cat $FINALRESULTDIR/nodes.mac | awk '{print $1}' | head -n 1`
                   ;;
            esac

            MODE=`echo $line | awk '{print $4}'`
            ELEMENT=`echo $line | awk '{print $5}'`
            HANDLER=`echo $line | awk '{print $6}'`

            SLEEPTIME=`expr $NEXTTIME - $CTLTIME`

            echo "- $SLEEPTIME - $NEXTTIME - $CTLTIME -"

            if [ $SLEEPTIME -ne 0 ]; then
              sleep $SLEEPTIME
            fi

            for n in $NODES; do
              if [ "$MODE" = "xwrite" ]; then
                VALUE=`echo $line | awk '{print $7}'`
              else
                VALUE=""
              fi

              RES=1
              T=0

              while [ $RES -ne 0 ] && [ $T -lt 3 ]; do
                clickctrl.sh $MODE $n 7777 $ELEMENT $HANDLER $VALUE > $FINALRESULTDIR/measurement_ctl.xml.node_tmp
                RES=$?
                let T=T+1
              done
              cat $FINALRESULTDIR/measurement_ctl.xml.node_tmp >> $FINALRESULTDIR/measurement_ctl.xml.tmp
            done

            rm -f $FINALRESULTDIR/measurement_ctl.xml.node_tmp
            CTLTIME=$NEXTTIME
          fi
        done < $DIR/linkstat.ctl
        ;;
    stop)
        ;;
    prestart)
        ;;
    poststop)
        mkdir $FINALRESULTDIR/evaluation/
        echo "<linkchannelstat>" > $FINALRESULTDIR/evaluation/measurement_ctl.xml
        cat $FINALRESULTDIR/measurement_ctl.xml.tmp | grep -v "<compoundhandler time" | grep -v "<handler name=" | sed "s#<\!\[CDATA\[##g" | sed "s#]]>##g" | grep -v "</handler>" >> $FINALRESULTDIR/evaluation/measurement_ctl.xml
        echo "</linkchannelstat>" >> $FINALRESULTDIR/evaluation/measurement_ctl.xml
        ;;
    *)
        echo "Unknown option: $1. Use: $0 [prestart|start|stop|poststop]!"
        ;;
esac

exit 0
