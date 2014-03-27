#! /bin/bash


runscripts/prepare_all_mst_min.sh;
runscripts/prepare_all_mst_max.sh;
run_para_sim.sh;

tar -czvf mst_min.tgz *_mst_min*;
rm -rf *_mst_min*;
tar -czvf mst_max.tgz *_mst_max*;
rm -rf *_mst_max*;
echo 'min and max finished!'

runscripts/prepare_all_mst_mean.sh;
run_para_sim.sh;

tar -czvf mst_mean.tgz *_mst_mean*;
rm -rf *_mst_mean*;
echo 'mean finished';
