#! /bin/bash

cp 62_4_cluster/flooding.ctl flooding.ctl;
cp 62_4_cluster/flooding.des flooding.des;
cp 62_4_cluster/flooding.mes flooding.mes;
cp 62_4_cluster/placement.txt placement.txt;

sed 's/circles1_1/62_4_cluster_5_75_5000/g' < 62_4_cluster/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_cluster_5_75_5000_bd;
sed 's/circles1_1/62_4_cluster_10_75_5000/g' < 62_4_cluster/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_cluster_10_75_5000_bd;
sed 's/circles1_1/62_4_cluster_15_75_5000/g' < 62_4_cluster/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_cluster_15_75_5000_bd;
sed 's/circles1_1/62_4_cluster_20_75_5000/g' < 62_4_cluster/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_cluster_20_75_5000_bd;
sed 's/circles1_1/62_4_cluster_5_85_5000/g' < 62_4_cluster/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_cluster_5_85_5000_bd;
sed 's/circles1_1/62_4_cluster_10_85_5000/g' < 62_4_cluster/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_cluster_10_85_5000_bd;
sed 's/circles1_1/62_4_cluster_15_85_5000/g' < 62_4_cluster/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_cluster_15_85_5000_bd;
sed 's/circles1_1/62_4_cluster_20_85_5000/g' < 62_4_cluster/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 62_4_cluster_20_85_5000_bd;
