#!/bin/sh

. $CONFIGFILE

F1_1=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | grep "flowid=\"0\"" | tail -n 1 | sed 's#"# #g' | sed "s#=# #g" | awk '{print $17}'`
F1_2=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | grep "flowid=\"0\"" | head -n 1 | sed 's#"# #g' | sed "s#=# #g" | awk '{print $17}'`
F2_1=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | grep "flowid=\"1\"" | tail -n 1 | sed 's#"# #g' | sed "s#=# #g" | awk '{print $17}'`
F2_2=`cat $RESULTDIR/measurement.log | grep "<txflow src=" | grep "flowid=\"1\"" | head -n 1 | sed 's#"# #g' | sed "s#=# #g" | awk '{print $17}'`

let F1=\(100*F2_1\)/F1_1
let F2=\(100*F2_2\)/F1_2

let I=200-\(F1+F2\)

echo $I > $RESULTDIR/interference
echo $I

exit 0
