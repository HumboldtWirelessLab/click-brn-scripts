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

. $CONFIGFILE


for i in foobar103 ranger104 commander105 wendy106 pc113 wgt55 seismo151 seismo158 seismo176 seismo162; do
  if [ -f $RESULTDIR/$i.ath0.raw.dump ]; then
    (cd $RESULTDIR;ATH=yes fromdump.sh $i.ath0.raw.dump | grep -v TX | grep -v ATHOPERATION | awk '{print $2" "$30" "$53" "$9" "$11" "$33" "$41" "$45" "$49" "$51" "$73" "$43" "$61" "$70}' | sed "s#:##g" | sed "s#(RX)#0#g" | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac > $EVALUATIONSDIR/regmon_dump_info_$i )
    (cd $RESULTDIR;ATH=yes fromdump.sh $i.ath0.raw.dump | grep -v RX | grep -v ATHOPERATION | awk '{print $2" "$30" "$53" "$9" "$11" "$33" "$41" "$45" "$49" "$51" "$73" "$43" "$61" "$70}' | sed "s#:##g" | sed "s#(RX)#0#g" | MAC2NUM=1 human_readable.sh $RESULTDIR/nodes.mac > $EVALUATIONSDIR/regmon_dump_txinfo_$i )

    MACS=`(cat $EVALUATIONSDIR/regmon_dump_info_$i $EVALUATIONSDIR/regmon_dump_info_$i | awk '{print $14}' | grep "-" | sort -u)`

    NODEMAC_SEDARG=""
    NUM=`cat $RESULTDIR/nodes.mac | wc -l`

    #echo "$MACS"
    if [ "x$MACS" != "x" ]; then

      for m in $MACS; do
        let NUM=NUM+1
        NODEMAC_SEDARG="$NODEMAC_SEDARG -e s#$m#$NUM#g"
      done

      #echo $NODEMAC_SEDARG

      cat $EVALUATIONSDIR/regmon_dump_info_$i | sed $NODEMAC_SEDARG > $EVALUATIONSDIR/regmon_dump_info_$i.tmp
      mv $EVALUATIONSDIR/regmon_dump_info_$i.tmp $EVALUATIONSDIR/regmon_dump_info_$i

    fi

    if [ -f $RESULTDIR/regmon_data_$i ]; then
      (cd $RESULTDIR;regmon_hex2dec.sh regmon_data_$i; mv regmon_data_$i.dec $EVALUATIONSDIR/)
    fi
    #echo "full_analyze('$EVALUATIONSDIR/regmon_dump_info_$i','$EVALUATIONSDIR/regmon_data_$i.dec')"
    #(cd $DIR; matlab -nosplash -nodesktop -nojvm -nodisplay -r "try,full_analyze('$EVALUATIONSDIR/regmon_dump_info_$i','$EVALUATIONSDIR/regmon_data_$i.dec'),catch,exit(1),end,exit(0)" 1> /dev/null)
    if [ ! -e $EVALUATIONSDIR/$i ]; then
      mkdir $EVALUATIONSDIR/$i
    fi
    #mv $DIR/*.png $EVALUATIONSDIR/$i
    #mv $DIR/*.eps $EVALUATIONSDIR/$i
  fi
done

#if [ -f $RESULTDIR/regmon_data_foobar103.dec ] && [ -f $RESULTDIR/regmon_data_commander105.dec ]; then
#    (cd $DIR; matlab -nosplash -nodesktop -nojvm -nodisplay -r "try,full_analyze_rxtx('$EVALUATIONSDIR/regmon_dump_info_foobar103','$EVALUATIONSDIR/regmon_data_foobar103.dec','$EVALUATIONSDIR/regmon_dump_info_commander105','$EVALUATIONSDIR/regmon_data_commander105.dec'),catch,exit(1),end,exit(0)" 1> /dev/null)
#    mv -f $DIR/*.png $DIR/*.eps $EVALUATIONSDIR
#fi
exit 0

