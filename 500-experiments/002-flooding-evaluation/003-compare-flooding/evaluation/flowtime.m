addpath('filter/')

%basedir='20141014/';
%basedir='20141014b-gridrand/';
%basedir='20141015-small/';
%basedir='20141015-big/';
%basedir='20150128/';
basedir='20150208b/';
%basedir='';
  
if (~exist('basedir'))
  basedir='20140912/';
end

clear filterhandle
filterhandle=@mpr_filter
functions(filterhandle)

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

configs=unique(index(:,CFG_INDEX),'rows');
configs=[configs'; [1:size(configs,1)]]';             %add index at the end 

%CFG_INDEX

size(summary)
size(configs)

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
  results_per_config = size(index,1) / size(configs,1);
  
  reach_res=zeros(results_per_config,size(configs,1));
  pkt_res=zeros(results_per_config,size(configs,1));
  col_res=zeros(results_per_config,size(configs,1));

  cur_r=zeros(1,results_per_config);
  cur_p=zeros(1,results_per_config);
  cur_c=zeros(1,results_per_config);

  for uc=1:size(configs,1)
    cur_uc=configs(uc,1:end-1);
    c_inds=unique(index(ismember(index(:,CFG_INDEX),cur_uc,'rows'),CONFIGID));

    %size(c_inds)

    cur_r(:)=nan;
    cur_p(:)=nan;
    cur_c(:)=nan;
    
    for c=1:size(c_inds,1)

        i=find(index(:,CONFIGID)==c_inds(c));

        cur_r(c) = summary(i,REACH);
        cur_p(c) = summary(i,CNT_TX_PKT);
        cur_c(c) = summary(i,COL);
    end

    reach_res(:,configs(uc,end)) = cur_r;
    pkt_res(:,configs(uc,end)) = cur_p;
    col_res(:,configs(uc,end)) = cur_c;
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

plotold=1;
if ( plotold == 1)
  
  show_configs=configs;

  filterhandle()
  
  search_for_best = 0+;
  if (search_for_best == 1)
      check_all_best = 1;
      if (check_all_best == 1)
        for i = 1:CONFIG_OVERLAY
        %for i = CONFIG_MAXDELAY:CONFIG_MAXDELAY
          if ( size(unique(show_configs(:,i)),1) ~= 1)
            %test_params(show_configs, result, [CONFIG_UNICASTSTRATEGY i], [RESULT_PKT_CNT RESULT_TIMES]);
            test_params(show_configs, result, [CONFIG_UNICASTSTRATEGY i], [RESULT_PKT_CNT RESULT_REACH]);
          end
        end
      end

      %f=g+1
   
      legend_params = [CONFIG_UNICASTSTRATEGY CONFIG_TXABORT];
   
      show_configs_1=show_configs(show_configs(:,CONFIG_NBMETRIC) == 400,:);

      show_configs_2=show_configs(show_configs(:,CONFIG_NBMETRIC) == 8000,:);

      test_params(show_configs_1, result, legend_params, [RESULT_PKT_CNT RESULT_TIMES]);
      test_params(show_configs_1, result, legend_params, [RESULT_PKT_CNT RESULT_REACH]);
     
      test_params(show_configs_2, result, legend_params, [RESULT_PKT_CNT RESULT_TIMES]);
      test_params(show_configs_2, result, legend_params, [RESULT_PKT_CNT RESULT_REACH]);

  else
      legend_params = [CONFIG_UNICASTSTRATEGY CONFIG_FLOODING_NET_RETRIES];
      test_params(show_configs, result, legend_params, [RESULT_PKT_CNT RESULT_TIMES]);
      test_params(show_configs, result, legend_params, [RESULT_PKT_CNT RESULT_REACH]);
  end
end

plot_scatter = 0;
if plot_scatter == 1

    h1 = figure;
    
    show_reach_res = reach_res(:,show_configs(:,end));
    boxplot(show_reach_res,show_configs(:,end));

    title('scheme vs reach');
    xlabel('scheme');
    ylabel('reach');
    %legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
    grid on;

    saveas(h1, 'reach.png' ,'png');
    saveas(h1, 'reach.eps' ,'epsc');

    h1 = figure;

    show_pkt_res = pkt_res(:,show_configs(:,end));
    boxplot(show_pkt_res,show_configs(:,end));

    title('scheme vs pkt');
    xlabel('scheme');
    ylabel('#pkts');
    %legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
    grid on;

    saveas(h1, 'pkt.png' ,'png');
    saveas(h1, 'pkt.eps' ,'epsc');

    h1 = figure;

    show_col_res = col_res(:,show_configs(:,end));
    boxplot(show_col_res,show_configs(:,end));

    title('scheme vs colisions');
    xlabel('scheme');
    ylabel('#pcols');
    %legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'southwest');
    grid on;

    saveas(h1, 'col.png' ,'png');
    saveas(h1, 'col.eps' ,'epsc');

end

