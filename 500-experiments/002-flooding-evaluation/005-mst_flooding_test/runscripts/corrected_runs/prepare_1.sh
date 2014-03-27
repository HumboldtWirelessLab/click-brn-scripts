#! /bin/bash

cp controlfiles/flooding10.ctl flooding.ctl;
cp controlfiles/flooding10.des flooding.des;
cp controlfiles/flooding10.mes flooding.mes;

sed 's/circles1_1/circles1_1/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_1_bd;
echo -e "1_1_bd finished\n";
sed 's/circles1_1/circles1_2/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_2_bd;
echo -e "1_2_bd finished\n";
sed 's/circles1_1/circles1_3/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_3_bd;
echo -e "1_3_bd finished\n";
sed 's/circles1_1/circles1_4/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_4_bd;
echo -e "1_4_bd finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_smpl;
echo -e "1_smpl finished\n";

sed 's/circles1_1/circles1_1/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_1_sd;
echo -e "1_1_sd finished\n";
sed 's/circles1_1/circles1_2/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_2_sd;
echo -e "1_2_sd finished\n";
sed 's/circles1_1/circles1_3/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_3_sd;
echo -e "1_3_sd finished\n";
sed 's/circles1_1/circles1_4/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_4_sd;
echo -e "1_4_sd finished\n";
