for i in `ls`; do N=`echo $i | sed "s#_# #g" | awk '{print $1}'`; if [ -f $i/txpower_data.mat ]; then cat $i/txpower_data.mat | awk -v NUM=$N '{print NUM" "$0}'; fi;done > all_results.mat
for i in `ls`; do N=`echo $i | sed "s#_# #g" | awk '{print $1}'`; if [ -f $i/txpower_data.mat ]; then cat $i/txpower_data.mat | awk -v NUM=$N '{print NUM" "$0}'; fi;done > all_results.mat

