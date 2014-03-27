#! /bin/bash

cp multibox2/flooding.ctl flooding.ctl;
cp multibox2/flooding.des flooding.des;
cp multibox2/flooding.mes flooding.mes;
cp multibox2/multibox2.plm multibox2.plm;

sed 's/circles1_1/multibox2_5_75_5000/g' < multibox2/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_5_75_5000_sd;
echo "5_75_5000 done";
sed 's/circles1_1/multibox2_10_75_5000/g' < multibox2/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_10_75_5000_sd;
echo "10_75_5000 done";
sed 's/circles1_1/multibox2_15_75_5000/g' < multibox2/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_15_75_5000_sd;
echo "15_75_5000 done";
sed 's/circles1_1/multibox2_20_75_5000/g' < multibox2/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_20_75_5000_sd;
echo "20_75_5000 done";
sed 's/circles1_1/multibox2_5_85_5000/g' < multibox2/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_5_85_5000_sd;
echo "5_85_5000 done";
sed 's/circles1_1/multibox2_10_85_5000/g' < multibox2/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_10_85_5000_sd;
echo "10_85_5000 done";
sed 's/circles1_1/multibox2_15_85_5000/g' < multibox2/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_15_85_5000_sd;
echo "15_85_5000 done";
sed 's/circles1_1/multibox2_20_85_5000/g' < multibox2/flooding_sd.click > flooding.click;
PREPARE_ONLY=1 run_sim.sh ns flooding.des multibox2_20_85_5000_sd;
echo "20_85_5000 done";
