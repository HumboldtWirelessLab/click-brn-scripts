#! /bin/bash

cp controlfiles/flooding10.ctl flooding.ctl;
cp controlfiles/flooding10.des flooding.des;
cp controlfiles/flooding10.mes flooding.mes;

sed 's/circles1_1/1_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_mst_min;
echo 'Finished 1';

cp controlfiles/flooding50.ctl flooding.ctl;
cp controlfiles/flooding50.des flooding.des;
cp controlfiles/flooding50.mes flooding.mes;

sed 's/circles1_1/2_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_mst_min;
echo 'Finished 2';

cp controlfiles/flooding100.ctl flooding.ctl;
cp controlfiles/flooding100.des flooding.des;
cp controlfiles/flooding100.mes flooding.mes;

sed 's/circles1_1/3_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_mst_min;
echo 'Finished 3';

cp 62_4_cluster/flooding.ctl flooding.ctl;
cp 62_4_cluster/flooding.des flooding.des;
cp 62_4_cluster/flooding.mes flooding.mes;
cp 62_4_cluster/placement.txt placement.txt;

sed 's/circles1_1/62_4_clusters_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_clusters_mst_min;
echo 'Finished 62_4_clusters';

cp 97_5_clusters/flooding.ctl flooding.ctl;
cp 97_5_clusters/flooding.des flooding.des;
cp 97_5_clusters/flooding.mes flooding.mes;
cp 97_5_clusters/97_5_clusters.plm 97_5_clusters.plm;

sed 's/circles1_1/97_5_clusters_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_mst_min;
echo 'Finished 97_5_clusters';

cp multibox1/flooding.ctl flooding.ctl;
cp multibox1/flooding.des flooding.des;
cp multibox1/flooding.mes flooding.mes;
cp multibox1/multibox1.plm multibox1.plm;

sed 's/circles1_1/multibox1_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox1_mst_min;
echo 'Finished multibox1';

cp multibox2/flooding.ctl flooding.ctl;
cp multibox2/flooding.des flooding.des;
cp multibox2/flooding.mes flooding.mes;
cp multibox2/multibox2.plm multibox2.plm;

sed 's/circles1_1/multibox2_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_mst_min;
echo 'Finished multibox2';

cp multibox3/flooding.ctl flooding.ctl;
cp multibox3/flooding.des flooding.des;
cp multibox3/flooding.mes flooding.mes;
cp multibox3/multibox3.plm multibox3.plm;

sed 's/circles1_1/multibox3_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox3_mst_min;
echo 'Finished multibox3';
