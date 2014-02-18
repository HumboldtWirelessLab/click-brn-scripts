#! /bin/bash

cp controlfiles/flooding50.ctl flooding.ctl;
cp controlfiles/flooding50.des flooding.des;
cp controlfiles/flooding50.mes flooding.mes;

sed 's/circles1_1/circles2_1/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_1_bd;
echo -e "2_1_bd finished\n";
sed 's/circles1_1/circles2_2/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_2_bd;
echo -e "2_2_bd finished\n";
sed 's/circles1_1/circles2_3/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_3_bd;
echo -e "2_3_bd finished\n";
sed 's/circles1_1/circles2_4/g' < controlfiles/flooding_bd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_4_bd;
echo -e "2_4_bd finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_smpl;
echo -e "2_smpl finished\n";

sed 's/circles1_1/circles2_1/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_1_sd;
echo -e "2_1_sd finished\n";
sed 's/circles1_1/circles2_2/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_2_sd;
echo -e "2_2_sd finished\n";
sed 's/circles1_1/circles2_3/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_3_sd;
echo -e "2_3_sd finished\n";
sed 's/circles1_1/circles2_4/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_4_sd;
echo -e "2_4_sd finished\n";
