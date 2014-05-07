#! /bin/bash

rm -rf 1 2 3 4 5 6 7 8 9

#cp controlfiles/flooding.click flooding.click;
#cp controlfiles/flooding10.ctl flooding.ctl;
#cp controlfiles/flooding10.des flooding.des;
#cp controlfiles/flooding10.mes flooding.mes;

#cp circles_konvertiert/circles1_1 circles
#run_sim.sh
#mv 1 1_1
#echo -e "\n1_1 finished\n";
#cp circles_konvertiert/circles1_2 circles
#run_sim.sh
#mv 1 1_2
#echo -e "\n1_2 finished\n";
#cp circles_konvertiert/circles1_3 circles
#run_sim.sh
#mv 1 1_3
#echo -e "\n1_3 finished\n";
#cp circles_konvertiert/circles1_4 circles
#run_sim.sh
#mv 1 1_4
#echo -e "\n1_4 finished\n";
#cp controlfiles/flooding_smpl.click flooding.click;
#run_sim.sh
#mv 1 1_smpl
#echo -e "\n1_smpl finished\n";

cp controlfiles/flooding.click flooding.click;
cp controlfiles/flooding50.ctl flooding.ctl;
cp controlfiles/flooding50.des flooding.des;
cp controlfiles/flooding50.mes flooding.mes;

#cp circles_konvertiert/circles2_1 circles
#run_sim.sh
#mv 1 2_1
#echo -e "\n2_1 finished\n";
#cp circles_konvertiert/circles2_2 circles
#run_sim.sh
#mv 1 2_2
#echo -e "\n2_2 finished\n";
#cp circles_konvertiert/circles2_3 circles
#run_sim.sh
#mv 1 2_3
#echo -e "\n2_3 finished\n";
#cp circles_konvertiert/circles2_4 circles
#run_sim.sh
#mv 1 2_4
#echo -e "\n2_4 finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
run_sim.sh
mv 1 2_smpl
echo -e "\n2_smpl finished\n";

cp controlfiles/flooding.click flooding.click;
cp controlfiles/flooding100.ctl flooding.ctl;
cp controlfiles/flooding100.des flooding.des;
cp controlfiles/flooding100.mes flooding.mes;

cp circles_konvertiert/circles3_1 circles
run_sim.sh
mv 1 3_1
echo -e "\n3_1 finished\n";
cp circles_konvertiert/circles3_2 circles
run_sim.sh
mv 1 3_2
echo -e "\n3_2 finished\n";
cp circles_konvertiert/circles3_3 circles
run_sim.sh
mv 1 3_3
echo -e "\n3_3 finished\n";
cp controlfiles/flooding_smpl.click flooding.click;
run_sim.sh
mv 1 3_smpl
echo -e "\n3_smpl finished\n";
