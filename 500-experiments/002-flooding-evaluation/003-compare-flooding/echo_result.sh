#!/bin/sh

echo "DATARATE_MBit_NUM_plm_pl_al_flunic_flunicpres_flunic_reject_flunic_peer_flparet_flmacret_flnbmet_flpiggy_flforceresp_fluseassign_flmaxdelay_flaborttx_flunicfixcs_fle2e_rtscts_rtsctsmixed_bos_rs_fltxsched_-unicast-_flunic_repetition"



for i in 1_MBit*; do echo -n "$i: ";
  cat $i/evaluation/flooding_info/floodingstats.csv | awk -F"," '{print $6" "$3}';
 # cat $i/flooding.click.eth0 | grep OverlayFlooding;
 # cat $i/evaluation/flow_info/flowtime.mat;
done

