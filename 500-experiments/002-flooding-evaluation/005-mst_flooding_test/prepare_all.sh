#! /bin/bash

cp controlfiles/flooding10.ctl flooding.ctl;
cp controlfiles/flooding10.des flooding.des;
cp controlfiles/flooding10.mes flooding.mes;

sed 's/circles1_1/circles1_1/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_1
sed 's/circles1_1/circles1_2/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_2
sed 's/circles1_1/circles1_3/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_3
sed 's/circles1_1/circles1_4/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_4

cp controlfiles/flooding50.ctl flooding.ctl;
cp controlfiles/flooding50.des flooding.des;
cp controlfiles/flooding50.mes flooding.mes;

sed 's/circles1_1/circles2_1/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_1
sed 's/circles1_1/circles2_2/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_2
sed 's/circles1_1/circles2_3/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_3
sed 's/circles1_1/circles2_4/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_4

cp controlfiles/flooding100.ctl flooding.ctl;
cp controlfiles/flooding100.des flooding.des;
cp controlfiles/flooding100.mes flooding.mes;

sed 's/circles1_1/circles3_1/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_1
sed 's/circles1_1/circles3_2/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_2
sed 's/circles1_1/circles3_3/g' < controlfiles/flooding.click > flooding.click
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_3
