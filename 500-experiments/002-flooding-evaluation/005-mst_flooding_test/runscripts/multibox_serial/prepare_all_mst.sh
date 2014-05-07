#! /bin/bash

cp multibox1/flooding.ctl flooding.ctl;
cp multibox1/flooding.des flooding.des;
cp multibox1/flooding.mes flooding.mes;
cp multibox1/multibox1.plm multibox1.plm;

sed 's/circles1_1/multibox1_mst.txt/g' < controlfiles/flooding_max_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox1_mst_max;
echo 'Finished max multibox1';

cp multibox2/flooding.ctl flooding.ctl;
cp multibox2/flooding.des flooding.des;
cp multibox2/flooding.mes flooding.mes;
cp multibox2/multibox2.plm multibox2.plm;

sed 's/circles1_1/multibox2_mst.txt/g' < controlfiles/flooding_max_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox2_mst_max;
echo 'Finished max multibox2';

cp multibox3/flooding.ctl flooding.ctl;
cp multibox3/flooding.des flooding.des;
cp multibox3/flooding.mes flooding.mes;
cp multibox3/multibox3.plm multibox3.plm;

sed 's/circles1_1/multibox3_mst.txt/g' < controlfiles/flooding_max_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox3_mst_max;
echo 'Finished max multibox3';

tar -czvf multibox_mst_max.tgz *_mst_max;
rm -rf *_mst_max;

cp multibox1/flooding.ctl flooding.ctl;
cp multibox1/flooding.des flooding.des;
cp multibox1/flooding.mes flooding.mes;
cp multibox1/multibox1.plm multibox1.plm;

sed 's/circles1_1/multibox1_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox1_mst_min;
echo 'Finished min multibox1';

cp multibox2/flooding.ctl flooding.ctl;
cp multibox2/flooding.des flooding.des;
cp multibox2/flooding.mes flooding.mes;
cp multibox2/multibox2.plm multibox2.plm;

sed 's/circles1_1/multibox2_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox2_mst_min;
echo 'Finished min multibox2';

cp multibox3/flooding.ctl flooding.ctl;
cp multibox3/flooding.des flooding.des;
cp multibox3/flooding.mes flooding.mes;
cp multibox3/multibox3.plm multibox3.plm;

sed 's/circles1_1/multibox3_mst.txt/g' < controlfiles/flooding_min_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox3_mst_min;
echo 'Finished min multibox3';

tar -czvf multibox_mst_min.tgz *_mst_min;
rm -rf *_mst_min;

cp multibox1/flooding.ctl flooding.ctl;
cp multibox1/flooding.des flooding.des;
cp multibox1/flooding.mes flooding.mes;
cp multibox1/multibox1.plm multibox1.plm;

sed 's/circles1_1/multibox1_mst.txt/g' < controlfiles/flooding_mean_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox1_mst_mean;
echo 'Finished mean multibox1';

cp multibox2/flooding.ctl flooding.ctl;
cp multibox2/flooding.des flooding.des;
cp multibox2/flooding.mes flooding.mes;
cp multibox2/multibox2.plm multibox2.plm;

sed 's/circles1_1/multibox2_mst.txt/g' < controlfiles/flooding_mean_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox2_mst_mean;
echo 'Finished mean multibox2';

cp multibox3/flooding.ctl flooding.ctl;
cp multibox3/flooding.des flooding.des;
cp multibox3/flooding.mes flooding.mes;
cp multibox3/multibox3.plm multibox3.plm;

sed 's/circles1_1/multibox3_mst.txt/g' < controlfiles/flooding_mean_mst.click > flooding.click;
run_sim.sh ns flooding.des multibox3_mst_mean;
echo 'Finished mean multibox3';

tar -czvf multibox_mst_mean.tgz *_mst_mean;
rm -rf *_mst_mean;
