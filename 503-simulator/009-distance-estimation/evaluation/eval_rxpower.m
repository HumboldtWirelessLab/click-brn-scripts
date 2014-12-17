
CHANNELMODEL=1;
DIST=2;
TIME=3;
PSIZE=4;
RATE=5;
SNR=6;
NOISE=7;

if (~exist('raw_data'))
  %raw_data=load('../result.dat','-ASCII');
  raw_data=load('../old/2_5__1/result.dat','-ASCII');
end

if (~exist('amall_data'))
  small_data=load('../old/2_5__1/result_dist.dat','-ASCII');
end

channel_models=unique(raw_data(:,CHANNELMODEL));
dists=sort(unique(raw_data(:,DIST)));

pdr_result=zeros(size(dists,1),size(channel_models,1));
snr_mean=zeros(size(dists,1),size(channel_models,1));
snr_max=zeros(size(dists,1),size(channel_models,1));
snr_min=zeros(size(dists,1),size(channel_models,1));
snr_stddev=zeros(size(dists,1),size(channel_models,1));
%just a hack
tx_packets=max(small_data(:,4))

for cm=1:size(channel_models,1)
  cm_data=raw_data(raw_data(:,CHANNELMODEL)==channel_models(cm),:);
  for d=1:size(dists,1)
    dist_data=cm_data(cm_data(:,DIST)==dists(d),:);
    if ( ~isempty(dist_data))
      pdr_result(d,cm)=size(dist_data,1)/tx_packets;
      snr_mean(d,cm)=mean(dist_data(:,SNR));
      snr_max(d,cm)=max(dist_data(:,SNR));
      snr_min(d,cm)=min(dist_data(:,SNR));
      snr_stddev(d,cm)=std(dist_data(:,SNR));
    else
      pdr_result(d,cm)=0;
      snr_result(d,cm)=0;
    end
    
    if (d==1)
      h1=figure;
      plot(dist_data([1:250],TIME), dist_data([1:250],SNR)); 
      xlabel('Time (s)');
      ylabel('SNR');
      saveas(h1, strcat(num2str(cm),'_time_vsa_snr.eps'),'epsc');
      %saveas(h1, strcat(num2str(cm),'_time_vs_snr.png'),'png');
    end
  end
  h1=figure;
  plot(dists,pdr_result(:,cm));
  xlabel('Dist (m)');
  ylabel('PDR');
  saveas(h1, strcat(num2str(cm),'_dist_vs_pdr.eps'),'epsc');
  %saveas(h1, strcat(num2str(cm),'_dist_vs_pdr.png'),'png');
  
  h1=figure;
  plot(dists,snr_mean(:,cm)); hold on;
  plot(dists,snr_min(:,cm)); hold on;
  plot(dists,snr_max(:,cm)); hold on;
  xlabel('Dist (m)');
  ylabel('SNR (db)');
  saveas(h1, strcat(num2str(cm),'_dist_vs_snr.eps'),'epsc');
  %saveas(h1, strcat(num2str(cm),'_dist_vs_snr.png'),'png');
  
  h1=figure;
  scatter(snr_mean(:,cm),pdr_result(:,cm));
  xlabel('SNR (db)');
  ylabel('PDR');
  saveas(h1, strcat(num2str(cm),'_snr_vs_pdr.eps'),'epsc');
  %saveas(h1, strcat(num2str(cm),'_snr_vs_pdr.png'),'png');
  
end

