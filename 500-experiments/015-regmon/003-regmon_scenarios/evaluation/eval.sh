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


for i in foobar103 pc113 ranger104 wgt55; do
  if [ -f $RESULTDIR/$i.ath0.raw.dump ]; then
    (cd $RESULTDIR;ATH=yes fromdump.sh $i.ath0.raw.dump | grep -v tx | grep -v ATHOPERATION | awk '{print $2" "$30" "$53" "$9" "$11" "$33" "$41" "$45" "$49" "$51" "$73}' | grep -v ":" | sed "s#(RX)#0#g" > ./regmon_dump_info )
    (cd $RESULTDIR;regmon_hex2dec.sh regmon_data)
  fi
done

#(cd $DIR; matlab -nosplash -nodesktop -nojvm -nodisplay -r "try,full_analyze('$EVALUATIONSDIR/regmon_dump_info','$EVALUATIONSDIR/regmon_data.dec'),catch,exit(1),end,exit(0)" 1> /dev/null)
#mv $DIR/*.png $DIR/*.eps $EVALUATIONSDIR

exit 0

