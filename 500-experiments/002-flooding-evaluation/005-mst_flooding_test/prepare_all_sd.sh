#! /bin/bash

cp controlfiles/flooding10.ctl flooding.ctl;
cp controlfiles/flooding10.des flooding.des;
cp controlfiles/flooding10.mes flooding.mes;

sed 's/circles1_1/circles1_1/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_1_all_source_singledirection;
echo -e "1_1 finished\n";
sed 's/circles1_1/circles1_2/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_2_all_source_singledirection;
echo -e "1_2 finished\n";
sed 's/circles1_1/circles1_3/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_3_all_source_singledirection;
echo -e "1_3 finished\n";
sed 's/circles1_1/circles1_4/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_4_all_source_singledirection;
echo -e "1_4 finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 1_smpl;
echo -e "1_smpl finished\n";

cp controlfiles/flooding50.ctl flooding.ctl;
cp controlfiles/flooding50.des flooding.des;
cp controlfiles/flooding50.mes flooding.mes;

sed 's/circles1_1/circles2_1/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_1_all_source_singledirection;
echo -e "2_1 finished\n";
sed 's/circles1_1/circles2_2/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_2_all_source_singledirection;
echo -e "2_2 finished\n";
sed 's/circles1_1/circles2_3/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_3_all_source_singledirection;
echo -e "2_3 finished\n";
sed 's/circles1_1/circles2_4/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_4_all_source_singledirection;
echo -e "2_4 finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 2_smpl;
echo -e "2_smpl finished\n";

cp controlfiles/flooding100.ctl flooding.ctl;
cp controlfiles/flooding100.des flooding.des;
cp controlfiles/flooding100.mes flooding.mes;

sed 's/circles1_1/circles3_1/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_1_all_source_singledirection;
echo -e "3_1 finished\n";
sed 's/circles1_1/circles3_2/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_2_all_source_singledirection;
echo -e "3_2 finished\n";
sed 's/circles1_1/circles3_3/g' < controlfiles/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_3_all_source_singledirection;
echo -e "3_3 finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des 3_smpl;
echo -e "3_smpl finished\n";
