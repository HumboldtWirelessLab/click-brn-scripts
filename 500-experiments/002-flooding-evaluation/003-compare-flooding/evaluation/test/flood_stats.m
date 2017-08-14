function flood_stats(fl_fwd_stats_file, rxtx_stats, start_time, end_time)

LASTNODE=1;
NODE=2;
SRC=3;

SIZE=4;
COUNT=10;

ID=11;
SENT=13;
RESP=15;

FOREIGN_RESP=16;
RX_ACK=17;
RX_COUNT=18;

FWD_DONE=19;
FWD_SUCC=20;

FIN_RESP=21;

TIME=22;

SECS=end_time-start_time;


%resp
resp_data=load(fl_fwd_stats_file,'-ASCII');
resp = resp_data(resp_data(:,RESP) == 1, [SRC ID NODE LASTNODE]);

ids = unique(resp_data(:,ID));
size_resp_id = zeros(max(ids),1);


%rxtx stats
data=load(rxtx_stats);
data_pre=data((data(:,1) < start_time),:);
data=data((data(:,1) >= start_time) & (data(:,1) <= end_time),:);

rx_data_pre=data_pre(data_pre(:,3) == 0,1);
tx_data_pre=data_pre(data_pre(:,3) == 1,1);

rx_hist_pre = hist(rx_data_pre,start_time);
tx_hist_pre = hist(tx_data_pre,start_time);
rxtx_frac_pre=rx_hist_pre./tx_hist_pre;

rx_hist_pre_mean=mean(rx_hist_pre);
tx_hist_pre_mean=mean(tx_hist_pre);

rx_data=data(data(:,3) == 0,1);
tx_data=data(data(:,3) == 1,1);

rx_hist = hist(rx_data,SECS)-rx_hist_pre_mean;
tx_hist = hist(tx_data,SECS)-tx_hist_pre_mean;
rxtx_frac=rx_hist./tx_hist;


%rx/tx per resp

sum(tx_hist)/size(resp,1)
size(resp,1)

end
