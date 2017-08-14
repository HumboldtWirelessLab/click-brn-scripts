function rxtx_info(filename, start_time, end_time)
SECS=end_time-start_time;

data=load(filename);
data=data((data(:,1) >= start_time) & (data(:,1) <= end_time),:);

rx_data=data(data(:,3) == 0,1);
tx_data=data(data(:,3) == 1,1);

figure;
hist(rx_data,SECS);
rx_hist = hist(rx_data,SECS);

figure;
hist(tx_data,SECS);
tx_hist = hist(tx_data,SECS);

rxtx_frac=rx_hist./tx_hist;

figure;
bar([start_time+1:end_time],rxtx_frac);

m = mean(rxtx_frac)
s = std(rxtx_frac)
