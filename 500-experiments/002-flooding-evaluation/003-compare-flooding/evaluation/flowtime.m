%basedir='20140912/';
basedir='';
  
if (~exist('basedir'))
  basedir='20140912/';
end

if (~exist('index'))
  index=load(strcat(basedir,'result_flooding_info_index.dat'),'-ASCII');
  summary=load(strcat(basedir,'result_flooding.dat'),'-ASCII');
  times=load(strcat(basedir,'result_flowtime.dat'),'-ASCII');
end

plot_cols=['r';'b';'k';'m';'c';'g';'y';'r';'m';'k';'b';'c';'y'];
plot_sign=['*';'+';'o';'x'];
scheduling_schemes_str = {'neighbours cnt','max delay','prio'};

INDEX=1;

%index
UNIC=4;
MAXDELAY=18;
ABORTTX=20;
SCHEDULING=27;

%flowtime
AVG_TIME=6;
MIN_TIME=7;
MAX_TIME=8;
AVG_TIME_PER_HOP=9;

%sum
REACH=2
CNT_TX_PKT=8;

configs=unique(index(:,[UNIC MAXDELAY ABORTTX SCHEDULING]),'rows')

%configs=configs(configs(:,1) == 0,:)
%configs=configs(configs(:,3) ~= 15,:)
%configs=configs(configs(:,4) == 3,:)

wo_delay=unique(index(:,[UNIC ABORTTX SCHEDULING]),'rows');

unicast_config=unique(index(:,[UNIC ABORTTX SCHEDULING]),'rows');
    
result=[];
scheme_labels = {};

for sc=1:size(configs,1)
    cur_sc=configs(sc,:);
    c_inds=unique(index(ismember(index(:,[UNIC MAXDELAY ABORTTX SCHEDULING]),cur_sc,'rows'),INDEX));

    %size(c_inds)
    %size(times)

    for c=1:size(c_inds,1)
        t=times(find(index(:,INDEX)==c_inds(c)),AVG_TIME);
        p=summary(find(index(:,INDEX)==c_inds(c)),CNT_TX_PKT);
        md=index(find(index(:,INDEX)==c_inds(c)),MAXDELAY);

        result=[result; [sc p t md]];
    end

end

reach_res=[];
pkt_res=[];

cur_r=zeros(1,size(unicast_config,1));
cur_p=zeros(1,size(unicast_config,1));

for uc=1:size(unicast_config,1)
    cur_uc=unicast_config(uc,:);
    c_inds=unique(index(ismember(index(:,[UNIC ABORTTX SCHEDULING]),cur_uc,'rows'),INDEX));

   
    for c=1:size(c_inds,1)
        cur_r(:)=nan;
        cur_p(:)=nan;
        cur_r(uc)=summary(find(index(:,INDEX)==c_inds(c)),REACH);
        cur_p(uc)=summary(find(index(:,INDEX)==c_inds(c)),CNT_TX_PKT);
        
        reach_res=[reach_res; cur_r];
        pkt_res=[pkt_res; cur_p];
    end

end

%result

scheduling_cfgs = sort(unique(index(:,SCHEDULING),'rows'));

for sc=1:size(scheduling_cfgs,1)
  scheme_labels = union(scheme_labels, scheduling_schemes_str(scheduling_cfgs(sc)), 'stable');
end

h1 = figure;

for sc=1:size(configs,1)
    cur_sc=configs(sc,:);

    r=result(find(result(:,1) == sc),[2 3]);

    scatter(r(:,1),r(:,2),20,plot_cols(cur_sc(4)));

    hold on;
end

title('Packet count vs avg delay');
xlabel('#Packet');
ylabel('Avg. delay (ms)');
legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
grid on;
xlim([0 max(result(:,2))*1.05]);
ylim([0 max(result(:,3))*1.05]);

saveas(h1, 'txscheduling.png' ,'png');
saveas(h1, 'txscheduling.eps' ,'epsc');

h1 = figure;

for sc=1:size(configs,1)
    cur_sc=configs(sc,:);

    r=result(find(result(:,1) == sc),[4 2]);

    scatter(r(:,1),r(:,2),20,plot_cols(cur_sc(4)));

    hold on;
end

title('max delay vs #pkts');
xlabel('#Max Delay per Hop');
ylabel('#Packets');
legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
grid on;
xlim([0 max(result(:,4))*1.05]);
ylim([0 max(result(:,2))*1.05]);

saveas(h1, 'maxdelay_vs_pkt.png' ,'png');
saveas(h1, 'maxdelay_vs_pkt.eps' ,'epsc');

h1 = figure;

for sc=1:size(configs,1)
    cur_sc=configs(sc,:);

    r=result(find(result(:,1) == sc),[4 3]);

    scatter(r(:,1),r(:,2),20,plot_cols(cur_sc(4)));

    hold on;
end

title('max delay vs avg delay');
xlabel('#Max Delay per Hop');
ylabel('Delay');
legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'northwest');
grid on;
xlim([0 max(result(:,4))*1.05]);
ylim([0 max(result(:,3))*1.05]);

saveas(h1, 'maxdelay_vs_delay.png' ,'png');
saveas(h1, 'maxdelay_vs_delay.eps' ,'epsc');

h1 = figure;

boxplot(reach_res,[1:size(unicast_config,1)]);

title('scheme vs reach');
xlabel('scheme');
ylabel('reach');
%legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
grid on;

saveas(h1, 'reach.png' ,'png');
saveas(h1, 'reach.eps' ,'epsc');

h1 = figure;

boxplot(pkt_res,[1:size(unicast_config,1)]);

title('scheme vs pkt');
xlabel('scheme');
ylabel('#pkts');
%legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
grid on;

saveas(h1, 'pkt.png' ,'png');
saveas(h1, 'pkt.eps' ,'epsc');

plot_scatter = 0;
if plot_scatter == 1

for c=1:size(wo_delay,1)
  h1 = figure;

  next_configs=unique(configs(ismember(configs(:,[1 3 4]),wo_delay(c,:),'rows'),:),'rows');
  delays=sort(next_configs(:,2));

  delay_labels = {};
  for sc=1:size(delays,1)
    delay_labels = union(delay_labels, num2str(delays(sc)), 'stable');
  end

  for dc=1:size(delays,1)

    n_cfg = next_configs(find(next_configs(:,2) == delays(dc)),:);

    n_cfg_index = find(ismember(configs(:,:),n_cfg,'rows') == 1);

    r=result(find(result(:,1) == n_cfg_index),[2 3]);

    scatter(r(:,1),r(:,2),20,plot_cols(floor(dc/size(plot_sign,1))+1),plot_sign(mod(dc,size(plot_sign,1))+1));

    hold on;
  end

  title('Packet count vs avg delay');
  xlabel('#Packet');
  ylabel('Avg. delay (ms)');
  legend(findobj(gca,'Tag','Box'),delay_labels,'location', 'southwest');
  grid on;
  xlim([0 max(result(:,2))*1.05]);
  ylim([0 max(result(:,3))*1.05]);

  saveas(h1, strcat('config_',num2str(c),'.png') ,'png');
  saveas(h1, strcat('config_',num2str(c),'.eps') ,'epsc');
end
end
