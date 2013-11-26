#! /bin/bash

rm -rf 1 2 3 4 5 6 7 8 9

cp controlfiles/flooding.click flooding.click;
cp controlfiles/flooding10.ctl flooding.ctl;
cp controlfiles/flooding10.des flooding.des;
cp controlfiles/flooding10.mes flooding.mes;

cp circles_konvertiert/circles1_1 circles
run_sim.sh
mv 1 1_1
echo -e "\n1_1 finished\n";
cp circles_konvertiert/circles1_2 circles
run_sim.sh
mv 1 1_2
echo -e "\n1_2 finished\n";
cp circles_konvertiert/circles1_3 circles
run_sim.sh
mv 1 1_3
echo -e "\n1_3 finished\n";
cp circles_konvertiert/circles1_4 circles
run_sim.sh
mv 1 1_4
echo -e "\n1_4 finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
run_sim.sh
mv 1 1_smpl
echo -e "\n1_smpl finished\n";
