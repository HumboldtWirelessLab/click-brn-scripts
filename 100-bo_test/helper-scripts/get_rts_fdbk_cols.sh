if [ "x$1" == "x" ]; then
  DIR=1
else
  DIR=$1
fi

sh helper-scripts/get_rts_cnt.sh $DIR | grep -v " 0"; sh helper-scripts/get_fdbk_count.sh $DIR; echo ""; sh helper-scripts/get_cols.sh $DIR
