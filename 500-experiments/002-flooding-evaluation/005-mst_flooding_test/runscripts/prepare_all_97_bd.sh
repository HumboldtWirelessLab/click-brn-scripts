#! /bin/bash

cp 97_5_clusters/flooding.ctl flooding.ctl;
cp 97_5_clusters/flooding.des flooding.des;
cp 97_5_clusters/flooding.mes flooding.mes;
cp 97_5_clusters/97_5_clusters.plm 97_5_clusters.plm;

sed 's/circles1_1/97_5_clusters_5_75_5000/g' < 97_5_clusters/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_5_75_5000_bd;
echo "5_75_5000 done";
sed 's/circles1_1/97_5_clusters_10_75_5000/g' < 97_5_clusters/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_10_75_5000_bd;
echo "10_75_5000 done";
sed 's/circles1_1/97_5_clusters_15_75_5000/g' < 97_5_clusters/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_15_75_5000_bd;
echo "15_75_5000 done";
sed 's/circles1_1/97_5_clusters_20_75_5000/g' < 97_5_clusters/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_20_75_5000_bd;
echo "20_75_5000 done";
sed 's/circles1_1/97_5_clusters_5_85_5000/g' < 97_5_clusters/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_5_85_5000_bd;
echo "5_85_5000 done";
sed 's/circles1_1/97_5_clusters_10_85_5000/g' < 97_5_clusters/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_10_85_5000_bd;
echo "10_85_5000 done";
sed 's/circles1_1/97_5_clusters_15_85_5000/g' < 97_5_clusters/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_15_85_5000_bd;
echo "15_85_5000 done";
sed 's/circles1_1/97_5_clusters_20_85_5000/g' < 97_5_clusters/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 97_5_clusters_20_85_5000_bd;
echo "20_85_5000 done";
