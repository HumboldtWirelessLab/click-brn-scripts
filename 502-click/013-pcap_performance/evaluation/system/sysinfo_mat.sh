#!/bin/sh

for i in `seq 1 10`; do
./grabsysinfo.pl 2>/dev/null | xsltproc systomat.xslt -
#cat ./data.txt | xsltproc systomat.xslt -
#./grabsysinfo.pl > ./data.txt
sleep 60
done
