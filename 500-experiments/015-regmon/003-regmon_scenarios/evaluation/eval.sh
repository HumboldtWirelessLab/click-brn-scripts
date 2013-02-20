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


for i in foobar103 ranger104 commander105 wendy106 pc113 wgt55; do
  if [ -f $RESULTDIR/$i.ath0.raw.dump ]; then
    (cd $RESULTDIR;ATH=yes fromdump.sh $i.ath0.raw.dump | grep -v tx | grep -v ATHOPERATION | awk '{print $2" "$30" "$53" "$9" "$11" "$33" "$41" "$45" "$49" "$51" "$73}' | grep -v ":" | sed "s#(RX)#0#g" > $EVALUATIONSDIR/regmon_dump_info_$i )
    (cd $RESULTDIR;regmon_hex2dec.sh regmon_data_$i; mv regmon_data_$i $EVALUATIONSDIR/)
    (cd $DIR; matlab -nosplash -nodesktop -nojvm -nodisplay -r "try,full_analyze('$EVALUATIONSDIR/regmon_dump_info_$i','$EVALUATIONSDIR/regmon_data_$i.dec'),catch,exit(1),end,exit(0)" 1> /dev/null)
    if [ ! -e $EVALUATIONSDIR/$i ]; then
      mkdir $EVALUATIONSDIR/$i
    fi
    mv -f $DIR/*.png $EVALUATIONSDIR/$i
    mv $DIR/*.eps $EVALUATIONSDIR/$i
  fi
done

#if [ -f $RESULTDIR/regmon_data_foobar103.dec ] && [ -f $RESULTDIR/regmon_data_commander105.dec ]; then
#    (cd $DIR; matlab -nosplash -nodesktop -nojvm -nodisplay -r "try,full_analyze_rxtx('$EVALUATIONSDIR/regmon_dump_info_foobar103','$EVALUATIONSDIR/regmon_data_foobar103.dec','$EVALUATIONSDIR/regmon_dump_info_commander105','$EVALUATIONSDIR/regmon_data_commander105.dec'),catch,exit(1),end,exit(0)" 1> /dev/null)
#    mv -f $DIR/*.png $DIR/*.eps $EVALUATIONSDIR
#fi
exit 0

