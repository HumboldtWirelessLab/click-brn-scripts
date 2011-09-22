#!/bin/sh

echo -n "" > result.txt

for i in 16 25 36 49 64 81 100; do

cat dht_dsr.des | sed "s#dht_dsr\.mes#dht_dsr_$i\.mes#g" > dht_dsr_$i.des
cat dht_dsr.mes | sed "s#nodes:9#nodes:$i#g" > dht_dsr_$i.mes

run_sim.sh ns dht_dsr_$i.des >> result.txt

rm -rf dht_dsr_$i.des dht_dsr_$i.mes

done
