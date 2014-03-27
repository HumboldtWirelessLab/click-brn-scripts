#! /bin/bash

cp controlfiles/flooding100.ctl flooding.ctl;
cp controlfiles/flooding100.des flooding.des;
cp controlfiles/flooding100.mes flooding.mes;

sed 's/circles1_1/circles3_1/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_1_bd;
echo -e "3_1_bd finished\n";
sed 's/circles1_1/circles3_2/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_2_bd;
echo -e "3_2_bd finished\n";
sed 's/circles1_1/circles3_3/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_3_bd;
echo -e "3_3_bd finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_smpl;
echo -e "3_smpl finished\n";

sed 's/circles1_1/circles3_1/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_1_sd;
echo -e "3_1_sd finished\n";
sed 's/circles1_1/circles3_2/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_2_sd;
echo -e "3_2_sd finished\n";
sed 's/circles1_1/circles3_3/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_3_sd;
echo -e "3_3_sd finished\n";
