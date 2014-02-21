#! /bin/bash

cp multibox1/flooding.ctl flooding.ctl;
cp multibox1/flooding.des flooding.des;
cp multibox1/flooding.mes flooding.mes;
cp multibox1/multibox1.plm multibox1.plm;

sed 's/circles1_1/multibox1_5_75_5000/g' < multibox1/flooding_sd.click > flooding.click;
run_sim.sh ns flooding.des multibox1_5_75_5000_sd;
echo "5_75_5000 done";
sed 's/circles1_1/multibox1_10_75_5000/g' < multibox1/flooding_sd.click > flooding.click;
run_sim.sh ns flooding.des multibox1_10_75_5000_sd;
echo "10_75_5000 done";
sed 's/circles1_1/multibox1_15_75_5000/g' < multibox1/flooding_sd.click > flooding.click;
run_sim.sh ns flooding.des multibox1_15_75_5000_sd;
echo "15_75_5000 done";
sed 's/circles1_1/multibox1_20_75_5000/g' < multibox1/flooding_sd.click > flooding.click;
run_sim.sh ns flooding.des multibox1_20_75_5000_sd;
echo "20_75_5000 done";
sed 's/circles1_1/multibox1_5_85_5000/g' < multibox1/flooding_sd.click > flooding.click;
run_sim.sh ns flooding.des multibox1_5_85_5000_sd;
echo "5_85_5000 done";
sed 's/circles1_1/multibox1_10_85_5000/g' < multibox1/flooding_sd.click > flooding.click;
run_sim.sh ns flooding.des multibox1_10_85_5000_sd;
echo "10_85_5000 done";
sed 's/circles1_1/multibox1_15_85_5000/g' < multibox1/flooding_sd.click > flooding.click;
run_sim.sh ns flooding.des multibox1_15_85_5000_sd;
echo "15_85_5000 done";
sed 's/circles1_1/multibox1_20_85_5000/g' < multibox1/flooding_sd.click > flooding.click;
run_sim.sh ns flooding.des multibox1_20_85_5000_sd;
echo "20_85_5000 done";

tar -czvf multibox1sd.tgz multibox1_*;
rm -rf multibox1_*;
