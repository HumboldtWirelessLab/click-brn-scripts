%basedir='20141014/';
%basedir='20141014b-gridrand/';
%basedir='20141015-small/';
%basedir='20141015-big/';
%basedir='20150128/';
basedir='20150202/';
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

CFG_INDEX=params_index;                               % alle relevanten spalten in der config

CFG_WO_DELAY_INDEX=CFG_INDEX(CFG_INDEX(:)~=MAXDELAY); % alle relevanten spalten in der config ohne delay

configs=unique(index(:,CFG_INDEX),'rows');
configs=[configs'; [1:size(configs,1)]]';             %add index at the end 

config_wo_delay=unique(index(:,CFG_WO_DELAY_INDEX),'rows')
config_wo_delay=[config_wo_delay';[1:size(config_wo_delay,1)]]';             %add index at the end 


%CFG_INDEX
%CFG_WO_DELAY_INDEX

size(summary)
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
    c_inds=unique(index(ismember(index(:,CFG_INDEX),cur_sc,'rows'),CONFIGID)); %config id in orig file

    %size(c_inds)
    %size(times)

    for c=1:size(c_inds,1)
        i=find(index(:,CONFIGID)==c_inds(c));
        t=times(i,AVG_TIME);
        p=summary(i,CNT_TX_PKT);
        md=index(i,MAXDELAY);
        r=summary(i,REACH);

        %result=[result; [sc p t md r]];
        result=[result; [configs(sc,end) p t md r]];
    end

  end
end

if (~exist('reach_res'))
  reach_res=[];
  pkt_res=[];
  col_res=[];

  cur_r=zeros(1,size(config_wo_delay,1));
  cur_p=zeros(1,size(config_wo_delay,1));
  cur_c=zeros(1,size(config_wo_delay,1));

  size(c_inds)

  for uc=1:size(config_wo_delay,1)
    cur_uc=config_wo_delay(uc,1:end-1);
    c_inds=unique(index(ismember(index(:,CFG_WO_DELAY_INDEX),cur_uc,'rows'),CONFIGID));

    for c=1:size(c_inds,1)
        cur_r(:)=nan;
        cur_p(:)=nan;
        cur_c(:)=nan;
        i=find(index(:,CONFIGID)==c_inds(c));

        cur_r(config_wo_delay(uc,end)) = summary(i,REACH);
        cur_p(config_wo_delay(uc,end)) = summary(i,CNT_TX_PKT);
        cur_c(config_wo_delay(uc,end)) = summary(i,COL);

        reach_res=[reach_res; cur_r];
        pkt_res=[pkt_res; cur_p];
        col_res=[col_res; cur_c];
    end

  end
end

%result
%size(result)

% P L O T T E N
plotall=0;
if ( plotall == 1)
  for i = 1:CONFIG_OVERLAY
    %test_params(configs, result, [i CONFIG_UNICASTSTRATEGY], [RESULT_PKT_CNT RESULT_TIMES]);
    test_params(configs, result, [i CONFIG_UNICASTSTRATEGY], [RESULT_PKT_CNT RESULT_REACH]);
  end
end

%f=g+1

plotold=0;
if ( plotold == 1)

  sim_num = 0;
  %sim_num = 20150128;
  
  show_configs=configs;
   
  if ( sim_num == 20150128 )
    show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) ~= 0,:);
    show_configs=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) ~= 0,:);
    show_configs=show_configs(show_configs(:,CONFIG_FLOODING_NET_RETRIES) == 5,:);
    show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) == 7,:); 
    show_configs=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) == 2,:);
    show_configs=show_configs(show_configs(:,CONFIG_TXSCHEDULING) == 0,:);    %TODO: warum hat 4 so ein hohes delay?
    show_configs=show_configs(show_configs(:,CONFIG_UNICAST_UCASTPEERMETRIC) == 0,:);
   
    legend_params = [CONFIG_UNICASTSTRATEGY CONFIG_UNICAST_UCASTPEERMETRIC];
    
    test_params(show_configs, result, legend_params, [RESULT_PKT_CNT RESULT_TIMES]);
    test_params(show_configs, result, legend_params, [RESULT_PKT_CNT RESULT_REACH]);
      
    show_configs=configs
    show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) == 0,:);
    show_configs=show_configs(show_configs(:,CONFIG_TXSCHEDULING) == 0,:);
    show_configs=show_configs(show_configs(:,CONFIG_FLOODING_NET_RETRIES) == 3,:);
  
    figurehandle = test_params(show_configs, result, legend_params, [RESULT_PKT_CNT RESULT_TIMES]);
    %saveas(figurehandle, char(strcat(basedir, '001.png')), 'png');
    %saveas(figurehandle, char(strcat(basedir, '001.eps')), 'epsc');
    figurehandle = test_params(show_configs, result, legend_params, [RESULT_PKT_CNT RESULT_REACH]);
    %saveas(figurehandle, char(strcat(basedir, '002.png')), 'png');
    %saveas(figurehandle, char(strcat(basedir, '002.eps')), 'epsc');
  end
  
  if ( sim_num == 10 )
    show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) ~= 0,:);
    show_configs=show_configs(show_configs(:,CONFIG_ALGORITHMID) == 3,:);
    show_configs=show_configs(show_configs(:,CONFIG_FLOODING_NET_RETRIES) == 3,:);
    show_configs=show_configs(show_configs(:,CONFIG_MAXDELAY) == 5,:);
    show_configs=show_configs(show_configs(:,CONFIG_UNICAST_PRESELECTION_STRATEGY) == 0,:);
    show_configs=show_configs(show_configs(:,CONFIG_OVERLAY) < 4,:);
   
    legend_params = [CONFIG_UNICASTSTRATEGY CONFIG_UNICAST_UCASTPEERMETRIC];
    
    %test_params(show_configs, result, legend_params, [RESULT_PKT_CNT RESULT_TIMES]);
    %test_params(show_configs, result, legend_params, [RESULT_PKT_CNT RESULT_REACH]);
  end
    
  %f=g+1
 
  %size(show_configs)
  show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) ~= 5,:);
  show_configs=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) ~= 8,:);
  show_configs
      
  search_for_best = 0;
  if (search_for_best == 1)
      %for i = 1:CONFIG_OVERLAY
      for i = CONFIG_UNICASTSTRATEGY:CONFIG_UNICASTSTRATEGY
        if ( size(unique(show_configs(:,i)),1) ~= 1)
          test_params(show_configs, result, [CONFIG_UNICASTSTRATEGY i], [RESULT_PKT_CNT RESULT_TIMES]);
          test_params(show_configs, result, [CONFIG_UNICASTSTRATEGY i], [RESULT_PKT_CNT RESULT_REACH]);
        end
      end

      %f=g+1
   
      legend_params = [CONFIG_UNICASTSTRATEGY CONFIG_UNICAST_UCASTPEERMETRIC];
           
      show_configs_1=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) == 3,:);
      test_params(show_configs_1, result, legend_params, [RESULT_PKT_CNT RESULT_TIMES]);
      %xlim([1500 2500]);
      test_params(show_configs_1, result, legend_params, [RESULT_PKT_CNT RESULT_REACH]);
      %xlim([1500 2500]);
     
      show_configs_2=show_configs(show_configs(:,CONFIG_UNICASTSTRATEGY) ~= 3,:);
      test_params(show_configs_2, result, legend_params, [RESULT_PKT_CNT RESULT_TIMES]);
      %xlim([1500 2500]);
      test_params(show_configs_2, result, legend_params, [RESULT_PKT_CNT RESULT_REACH]);
      %xlim([1500 2500]);
      
  end
end

plot_scatter = 1;
if plot_scatter == 1

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

end

