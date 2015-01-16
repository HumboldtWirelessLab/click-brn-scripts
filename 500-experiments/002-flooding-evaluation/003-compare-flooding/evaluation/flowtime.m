%basedir='20141014/';
%basedir='20141014b-gridrand/';
%basedir='20141015-small/';
%basedir='20141015-big/';
basedir='20150110/';
%basedir='';
  
if (~exist('basedir'))
  basedir='20140912/';
end

if (~exist('index'))
  index=load(strcat(basedir,'result_flooding_info_index.dat'),'-ASCII');
  summary=load(strcat(basedir,'result_flooding.dat'),'-ASCII');
  times=load(strcat(basedir,'result_flowtime.dat'),'-ASCII');
end

plot_cols=['r';'b';'k';'m';'c';'g';'y';'r';'m';'k';'b';'c';'y';'r';'b';'k';'m';'c';'g';'y';'r';'m';'k';'b';'c';'y'];
plot_sign=['*';'+';'o';'x';'.';'-'];
scheduling_schemes_str = {'neighbours cnt','maxdelay','prio'};
show_param_filestr = {'config', 'cntpacket' , 'avgdelay' , 'maxdelayperhop', 'reach' };

%load config vars
config_info

%flowtime
AVG_TIME=6;
MIN_TIME=7;
MAX_TIME=8;
AVG_TIME_PER_HOP=9;

%sum
REACH=2;
CNT_TX_PKT=8;
COL=10;

CFG_INDEX=params_index;

CFG_WO_DELAY_INDEX=CFG_INDEX(CFG_INDEX(:)~=MAXDELAY);

CFG_WO_DELAY_INDEX_IN_INDEX=[1:size(CFG_INDEX,2)];
CFG_WO_DELAY_INDEX_IN_INDEX=CFG_WO_DELAY_INDEX_IN_INDEX(CFG_INDEX(:)~=MAXDELAY);

params=unique(index(:,CFG_INDEX),'rows');

configs = params;

size(summary)
size(configs)

configs=[configs'; [1:size(configs,1)]]'; %add index at the end 
config_wo_delay=unique(configs(:,CFG_WO_DELAY_INDEX_IN_INDEX),'rows');

size(configs)
size(config_wo_delay)

RESULT_CONFIG=1;
RESULT_PKT_CNT=2;
RESULT_TIMES=3;
RESULT_MAXDELAY=4;
RESULT_REACH=5;

if (~exist('result'))
  result=[];
  scheme_labels = {};

  for sc=1:size(configs,1)
    cur_sc=configs(sc,1:end-1);
    c_inds=unique(index(ismember(index(:,CFG_INDEX),cur_sc,'rows'),CONFIGID));

    size(c_inds);
    %size(times)

    for c=1:size(c_inds,1)
        i=find(index(:,CONFIGID)==c_inds(c));
        t=times(i,AVG_TIME);
        p=summary(i,CNT_TX_PKT);
        md=index(i,MAXDELAY);
        r=summary(i,REACH);

        result=[result; [sc p t md r]];
    end

  end

  reach_res=[];
  pkt_res=[];
  col_res=[];

  cur_r=zeros(1,size(config_wo_delay,1));
  cur_p=zeros(1,size(config_wo_delay,1));
  cur_c=zeros(1,size(config_wo_delay,1));

  for uc=1:size(config_wo_delay,1)
    cur_uc=config_wo_delay(uc,:);
    c_inds=unique(index(ismember(index(:,CFG_WO_DELAY_INDEX),cur_uc,'rows'),CONFIGID));

    for c=1:size(c_inds,1)
        cur_r(:)=nan;
        cur_p(:)=nan;
        cur_c(:)=nan;
        i=find(index(:,CONFIGID)==c_inds(c));

        cur_r(uc) = summary(i,REACH);
        cur_p(uc) = summary(i,CNT_TX_PKT);
        cur_c(uc) = summary(i,COL);

        reach_res=[reach_res; cur_r];
        pkt_res=[pkt_res; cur_p];
        col_res=[pkt_res; cur_c];
    end

  end
end

%result
size(result)

% P L O T T E N
plotall=0;
if ( plotall == 1)
  for i = 2:CONFIG_TXSCHEDULING
    test_params(configs, result, [i CONFIG_UNICASTSTRATEGY], [RESULT_PKT_CNT RESULT_TIMES]);
  end
end

plotold=1;
if ( plotold == 1)
  %figurehandle = test_params(configs, result, [CONFIG_FLOODING_NET_RETRIES CONFIG_MACRETRIES], [RESULT_PKT_CNT RESULT_TIMES]);
  
  %saveas(figurehandle, char(strcat(basedir, '001.png')), 'png');
  %saveas(figurehandle, char(strcat(basedir, '001.eps')), 'epsc');

  %show_configs=configs(configs(:,CONFIG_UNICASTSTRATEGY) == 0,:);
  %test_params(show_configs, result, [CONFIG_FLOODING_NET_RETRIES CONFIG_MACRETRIES], [RESULT_PKT_CNT RESULT_TIMES]);
  
  %saveas(figurehandle, char(strcat(basedir, '002.png')), 'png');
  %saveas(figurehandle, char(strcat(basedir, '002.eps')), 'epsc');

  %show_configs=configs(configs(:,CONFIG_UNICASTSTRATEGY) == 4,:);
  %test_params(show_configs, result, [CONFIG_FLOODING_NET_RETRIES CONFIG_MACRETRIES], [RESULT_PKT_CNT RESULT_TIMES]);
  
  show_configs=configs
  show_configs=show_configs(configs(:,CONFIG_UNICASTSTRATEGY) == 7,:);
  %show_configs=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) == 2,:);
  show_configs=show_configs(show_configs(:,CONFIG_UNICAST_REJECTONEMPTYCS) == 1,:);
  show_configs=show_configs(show_configs(:,CONFIG_TXSCHEDULING) == 4,:);

  size(show_configs)
  
  search_for_best = 1;
  if (search_for_best == 1)
      for i = 2:CONFIG_TXSCHEDULING
        test_params(show_configs, result, [CONFIG_UNICASTSTRATEGY i], [RESULT_PKT_CNT RESULT_TIMES]);
      end

      show_configs_1=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) == 2,:);
      test_params(show_configs_1, result, [CONFIG_MACRETRIES CONFIG_FLOODING_NET_RETRIES], [RESULT_PKT_CNT RESULT_TIMES]);
      %xlim([1500 2500]);
      test_params(show_configs_1, result, [CONFIG_MACRETRIES CONFIG_FLOODING_NET_RETRIES], [RESULT_PKT_CNT RESULT_REACH]);
      %xlim([1500 2500]);

      show_configs_2=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) ~= 2,:);
      test_params(show_configs_2, result, [CONFIG_MACRETRIES CONFIG_FLOODING_NET_RETRIES], [RESULT_PKT_CNT RESULT_TIMES]);
      %xlim([1500 2500]);
      test_params(show_configs_2, result, [CONFIG_MACRETRIES CONFIG_FLOODING_NET_RETRIES], [RESULT_PKT_CNT RESULT_REACH]);
      %xlim([1500 2500]);

      f=g+1
  end
end

plot_testparams=0;
if plot_testparams == 0
    show_configs=configs(configs(:,CONFIG_UNICAST_REJECTONEMPTYCS) == 1,:);
    show_configs=show_configs(show_configs(:,CONFIG_TXSCHEDULING) == 4,:) % prio scheduling

    test_params(show_configs, result, [CONFIG_UNICAST_UCASTPEERMETRIC CONFIG_NBMETRIC], [2 3]);     % peermetric vs fix cand set

    show_configs=show_configs(show_configs(:,CONFIG_FIXCS) == 1,:); % use fix cand set
    test_params(show_configs, result, [CONFIG_UNICASTSTRATEGY CONFIG_FRESP], [2 3]);

    test_params(show_configs, result, [CONFIG_UNICASTSTRATEGY CONFIG_UNICAST_PRESELECTION_STRATEGY], [2 3]);
    test_params(show_configs, result, [CONFIG_UNICAST_PRESELECTION_STRATEGY CONFIG_UNICASTSTRATEGY], [2 3]);

    test_params(show_configs, result, [CONFIG_UNICASTSTRATEGY CONFIG_FLOODING_NET_RETRIES], [2 5]);
    test_params(show_configs, result, [CONFIG_FLOODING_NET_RETRIES CONFIG_UNICASTSTRATEGY], [2 5]);
end

plot_scatter = 0;
if plot_scatter == 1

    scheduling_cfgs = unique(configs(:,end),'rows');

    for sc=1:size(scheduling_cfgs,1)
      scheme_labels = union(scheme_labels, scheduling_schemes_str(scheduling_cfgs(sc)), 'stable');
    end

    h1 = figure;

    for sc=1:size(configs,1)
        cur_sc=configs(sc,:);

        r=result(find(result(:,1) == sc),[2 3]);

        scatter(r(:,1),r(:,2),20,plot_cols(cur_sc(5)),plot_sign(cur_sc(3)+1)); %end

        hold on;
    end

    title('Packet count vs avg delay');
    xlabel('#Packet');
    ylabel('Avg. delay (ms)');
    legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'northeast');
    grid on;
    xlim([0 max(result(:,2))*1.05]);
    ylim([0 max(result(:,3))*1.05]);

    saveas(h1, 'txscheduling.png' ,'png');
    saveas(h1, 'txscheduling.eps' ,'epsc');

    h1 = figure;

    for sc=1:size(configs,1)
        cur_sc=configs(sc,:);

        r=result(find(result(:,1) == sc),[4 2]);

        scatter(r(:,1),r(:,2),20,plot_cols(cur_sc(end)));

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

        scatter(r(:,1),r(:,2),20,plot_cols(cur_sc(end)));

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

    boxplot(reach_res,[1:size(config_wo_delay,1)]);

    title('scheme vs reach');
    xlabel('scheme');
    ylabel('reach');
    %legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
    grid on;

    saveas(h1, 'reach.png' ,'png');
    saveas(h1, 'reach.eps' ,'epsc');

    h1 = figure;

    boxplot(pkt_res,[1:size(config_wo_delay,1)]);

    title('scheme vs pkt');
    xlabel('scheme');
    ylabel('#pkts');
    %legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
    grid on;

    saveas(h1, 'pkt.png' ,'png');
    saveas(h1, 'pkt.eps' ,'epsc');

    h1 = figure;

    boxplot(col_res,[1:size(config_wo_delay,1)]);

    title('scheme vs colisions');
    xlabel('scheme');
    ylabel('#pcols');
    %legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
    grid on;

    saveas(h1, 'col.png' ,'png');
    saveas(h1, 'col.eps' ,'epsc');



    for c=1:size(config_wo_delay,1)
      h1 = figure;

      next_configs=unique(configs(ismember(configs(:,[1 2 3 5 6]),config_wo_delay(c,:),'rows'),:),'rows');
      delays=sort(next_configs(:,4));

      delay_labels = {};
      for sc=1:size(delays,1)
        delay_labels = union(delay_labels, num2str(delays(sc)), 'stable');
      end

      for dc=1:size(delays,1)

        n_cfg = next_configs(find(next_configs(:,4) == delays(dc)),:);

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
