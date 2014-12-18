
%VAR_RADIO $VAR_RXRANGE $VAR_FADING $VAR_PL_EXP $VAR_STD_DB $VAR_INIT_STD_DB $VAR_RICEAN_MAXV $VAR_RICEAN_K
CHANNELMODEL=1;
DIST=2;
FADING=3;
PL_EXP=4;
STD_DB=5;
INIT_STD_DB=6;
RICEAN_MAXV=7;
RICEAN_K=8;
ID = 9; %use end

TIME=1;
PSIZE=2;
RATE=3;
SNR=4;
NOISE=5;

% RADIO FADING PL_EXP STD_DB INIT_STD_DB RICEAN_MAXV RICEAN_K

CHANNELMODEL_STRING = { 'none', 'default', 'tworayground', 'shadowing', 'ricean', 'nakagami' };


plot_graph=1

if (~exist('raw_data'))
  %raw_data=load('../result.dat','-ASCII');
  %raw_data=load('../old/2_5__1/result.dat','-ASCII');
  raw_data=load('result.dat','-ASCII');
  raw_data_index=load('result_index.dat','-ASCII');
end

if (~exist('small_data'))
  %small_data=load('../old/2_5__1/result_dist.dat','-ASCII');
  small_data=load('result_dist.dat','-ASCII');
end

config_vector=[ CHANNELMODEL FADING:RICEAN_K ]

size(raw_data_index)

configs=unique(raw_data_index(:,config_vector),'rows');

configs=configs(((configs(:,1) == 2) | (configs(:,2) ~= 4)) & (configs(:,5) == 0) ,:)

dists=sort(unique(raw_data_index(:,DIST)))

pdr_result=zeros(size(dists,1),size(configs,1));
snr_mean=zeros(size(dists,1),size(configs,1));
snr_max=zeros(size(dists,1),size(configs,1));
snr_min=zeros(size(dists,1),size(configs,1));
snr_stddev=zeros(size(dists,1),size(configs,1));

%just a hack
tx_packets=max(small_data(:,2))

raw_data_full_index = raw_data(:,end);

for cfg=1:size(configs,1)
  %configs(cfg,:)
  config_str = strcat(CHANNELMODEL_STRING(configs(cfg,1)+1),'_',CHANNELMODEL_STRING(configs(cfg,2)+1),'_',num2str(configs(cfg,3)),'_',num2str(configs(cfg,4)),'_', ...
                  num2str(configs(cfg,5)),'_',num2str(configs(cfg,6)),'_',num2str(configs(cfg,7)))
  
  cfg_index = raw_data_index(ismember(raw_data_index(:,config_vector),configs(cfg,:),'rows'),:);
  
  %size(cfg_index)
  %size(dists)

  %get data for all dists
  cfg_data = raw_data(ismember(raw_data_full_index,cfg_index(:,end),'rows'),:);
  
  
  for d=1:size(dists,1)

    raw_data_dist_index = cfg_index(cfg_index(:,DIST) == dists(d), end);
    
    if (isempty(raw_data_dist_index)) 
      dist_data = raw_data_dist_index;
    else    
      dist_data=cfg_data(cfg_data(:,end) == raw_data_dist_index,:);
    end
    
    size(dist_data)

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
      title(config_str);
      saveas(h1, char(strcat(config_str,'_time_vsa_snr.eps')),'epsc');
      %saveas(h1, strcat(config_str,'_time_vs_snr.png'),'png');
    end
  end

  if (plot_graph==1)
    h1=figure;
    plot(dists,pdr_result(:,cfg));
    xlabel('Dist (m)');
    ylabel('PDR');
    title(config_str);
    saveas(h1, char(strcat(config_str,'_dist_vs_pdr.eps')),'epsc');
    %saveas(h1, strcat(config_str,'_dist_vs_pdr.png'),'png');

    h1=figure;
    plot(dists,snr_mean(:,cfg)); hold on;
    plot(dists,snr_min(:,cfg)); hold on;
    plot(dists,snr_max(:,cfg)); hold on;
    xlabel('Dist (m)');
    ylabel('SNR (db)');
    title(config_str);
    saveas(h1, char(strcat(config_str,'_dist_vs_snr.eps')),'epsc');
    %saveas(h1, strcat(config_str,'_dist_vs_snr.png'),'png');

    h1=figure;
    scatter(snr_mean(:,cfg),pdr_result(:,cfg));
    xlabel('SNR (db)');
    ylabel('PDR');
    title(config_str);
    saveas(h1, char(strcat(config_str,'_snr_vs_pdr.eps')),'epsc');
    %saveas(h1, strcat(config_str,'_snr_vs_pdr.png'),'png');
    close all;
  end

end

