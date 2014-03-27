#! /bin/bash

runscripts/corrected_runs/prepare_1.sh;
runscripts/corrected_runs/prepare_3.sh;
run_para_sim.sh;
tar -czvf 1sims.tgz 1_*;
tar -czvf 3sims.tgz 3_*;
rm -rf 1_*;
rm -rf 3_*;
echo "1 and 3 finished";

runscripts/corrected_runs/prepare_2.sh;
runscripts/corrected_runs/prepare_all_mst_min.sh;
run_para_sim.sh;

tar -czvf 2sims.tgz 2_*;
tar -czvf mstmin_sims.tgz *mst_*;
rm -rf 2_*;
rm -rf *mst_*;
echo "2 and mst_min finished";

runscripts/corrected_runs/prepare_all_62_bd.sh;
runscripts/corrected_runs/prepare_all_62_sd.sh;
run_para_sim.sh;

tar -czvf 62_4_clustersims.tgz 62_4_cluster_*;
rm -rf 62_4_cluster_*;
echo "62_4_cluster finished";

runscripts/corrected_runs/prepare_all_97_bd.sh;
runscripts/corrected_runs/prepare_all_97_sd.sh;
run_para_sim.sh;

tar -czvf 97_5_clustersims.tgz 97_5_clusters_*;
rm -rf 97_5_clusters_*;
echo "97_5_cluster finished";

#runscripts/corrected_runs/prepare_all_multibox1_bd.sh;
#runscripts/corrected_runs/prepare_all_multibox1_sd.sh;
#run_para_sim.sh;

#tar -czvf multibox1sims.tgz multibox1_*;
#rm -rf multibox1_*;
#echo "multibox1 finished";

#runscripts/corrected_runs/prepare_all_multibox2_bd.sh;
#runscripts/corrected_runs/prepare_all_multibox2_sd.sh;
#run_para_sim.sh;

#tar -czvf multibox2sims.tgz multibox2_*;
#rm -rf multibox2_*;
#echo "multibox2 finished";

#runscripts/corrected_runs/prepare_all_multibox3_bd.sh;
#runscripts/corrected_runs/prepare_all_multibox3_sd.sh;
#run_para_sim.sh;

#tar -czvf multibox3sims.tgz multibox3_*;
#rm -rf multibox3_*;
#echo "multibox3 finished";

runscripts/corrected_runs/prepare_all_mst_max.sh;
runscripts/corrected_runs/prepare_all_mst_mean.sh;
run_para_sim.sh;

tar -czvf mstmean_sims.tgz *mst_mean;
tar -czvf mstmax_sims.tgz *mst_max;
rm -rf *mst_*;
echo "mst_max and mst_mean finished";

echo "Finshished all!";
