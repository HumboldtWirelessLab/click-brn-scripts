
%VAR_RADIO $VAR_RXRANGE $VAR_FADING $VAR_PL_EXP $VAR_STD_DB $VAR_INIT_STD_DB $VAR_RICEAN_MAXV $VAR_RICEAN_K
CHANNELMODEL=1;
DIST=2;
FADING=3;
PL_EXP=4;
STD_DB=5;
INIT_STD_DB=6;
RICEAN_MAXV=7;
RICEAN_K=8;
TIME=9;
PSIZE=10;
RATE=11;
SNR=12;
NOISE=13;

plot_graph=0

if (~exist('raw_data'))
  %raw_data=load('../result.dat','-ASCII');
  %raw_data=load('../old/2_5__1/result.dat','-ASCII');
  raw_data=load('/dev/shm/result.dat','-ASCII');
end

if (~exist('small_data'))
  %small_data=load('../old/2_5__1/result_dist.dat','-ASCII');
  small_data=load('/dev/shm/result_dist.dat','-ASCII');
end

config_vector=[ CHANNELMODEL FADING:RICEAN_K ]
config_vector=[ CHANNELMODEL FADING:RICEAN_K ]

size(small_data)

configs=unique(small_data(:,config_vector+1))

dists=sort(unique(small_data(:,DIST+1)));

pdr_result=zeros(size(dists,1),size(configs,1));
snr_mean=zeros(size(dists,1),size(configs,1));
snr_max=zeros(size(dists,1),size(configs,1));
snr_min=zeros(size(dists,1),size(configs,1));
snr_stddev=zeros(size(dists,1),size(channel_models,1));

%just a hack
tx_packets=max(small_data(:,10))

for cfg=1:size(configs,1)

  cfg_data = raw_data(ismember(raw_data(:,config_vector),configs(cfg),'rows'),:);

  for d=1:size(dists,1)

    dist_data=cfg_data(cfg_data(:,DIST)==dists(d),:);

    if ( ~isempty(dist_data))
      pdr_result(d,cfg)=size(dist_data,1)/tx_packets;
      snr_mean(d,cfg)=mean(dist_data(:,SNR));
      snr_max(d,cfg)=max(dist_data(:,SNR));
      snr_min(d,cfg)=min(dist_data(:,SNR));
      snr_stddev(d,cfg)=std(dist_data(:,SNR));
    else
      pdr_result(d,cfg)=0;
      snr_mean(d,cfg)=0;
      snr_max(d,cfg)=0;
      snr_min(d,cfg)=0;
      snr_stddev(d,cfg)=0;
    end

    if ((d==1) && (plot_graph==1))
      h1=figure;
      plot(dist_data([1:250],TIME), dist_data([1:250],SNR)); 
      xlabel('Time (s)');
      ylabel('SNR');
      saveas(h1, strcat(num2str(cm),'_time_vsa_snr.eps'),'epsc');
      %saveas(h1, strcat(num2str(cm),'_time_vs_snr.png'),'png');
    end
  end

  if (plot_graph==0)
    exit;
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

