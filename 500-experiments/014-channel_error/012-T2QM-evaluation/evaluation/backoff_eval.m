NUM=1;
NO_NODES=2;
PACKETSIZE=3;
TTQM_STRATEGY=4;
RATE=5;
TARGET=6;
CHANNELMODEL=7;
QUEUEMAPPING=8;
MACBOSCHEME=9;

NODE=10;
BACKOFF=11;
BOUSAGE=12;
BOEXP=13;
LASTUSE=14;
PKTS_OVERALL=15;

COLLISIONS=66;

cm_string={'real';'shadowing';'2ray'};
target_string={'bcast';'ucast'};
tqm_string={ 'off';'on'};

sim_duration = 60;

print=1;
if ( ~(exist('a','var') ))
  disp('load data...')
  a=load('backoffusage.mat','-ASCII');
  %a=load('2014-08-07-shad/backoffusage.mat','-ASCII');
end

all_ps=unique(a(:,PACKETSIZE));
cmodel=unique(a(:,CHANNELMODEL))
configs=unique(a(:,[TTQM_STRATEGY QUEUEMAPPING MACBOSCHEME]),'rows')

%configs=configs(find((configs(:,1)==0) | (configs(:,2)==0) ),:) %stand vs bigger
%configs=configs(find((configs(:,1)==0) | (configs(:,2)==1) ),:) %stand vs smaller
configs=configs(find((configs(:,1)==0) | (configs(:,2)==2) ),:) %stand vs prob
%configs=configs(find((configs(:,1)==0) | (configs(:,1)==2) ),:) %stand vs max tp
%configs=configs(find((configs(:,1)==0) | (configs(:,1)==14) ),:) %stand vs prob

%configs=configs(find((configs(:,1)==0) | (configs(:,1)==2) ),:) %stand vs prob

configs=configs(find((configs(:,3)==1)),:) %stand

%configs=configs([1 2 3 5 8 11 12] ,:)
%configs=configs([1 7 8 9 11],:)

tqmmodes=unique(configs(:,1));

cmodel=[1];


all_targets=unique(a(:,TARGET));

plot_cols=['r';'m';'k';'b';'c';'g';'y';'r';'m';'k';'b';'c';'y'];

schemes = {'old 802.11','direct','max. tp','busy aware','target pkt loss','learning','target diff rx tx busy','neighbours','const','tx aware','flooding','11','12','13','mshare'};
queuemap_str = {'bigger','smaller','prob','grav','direct'};
queuemapdiff_str = {'exp','mul','add','fib'};
mac_schemes_str = {'default','exp','fib'};

scheme_labels = {};


for ii = 1:size(configs,1)
  scheme_labels = union(scheme_labels, strcat(schemes{configs(ii,1)+1},' - ',queuemap_str{configs(ii,2)+1},' - ', mac_schemes_str{configs(ii,3)+1}), 'stable');
end


plot_bo = 1;
plot_colls = 1;
plot_jfi = 1;
plot_sumtp = 1;
plot_nodetp = 0;

%                                                     TP     FAIR  Backoff
% blue  BACKOFF_STRATEGY_OFF                     0    +      +++   +++
%       BACKOFF_STRATEGY_DIRECT                  1
% green BACKOFF_STRATEGY_MAX_THROUGHPUT          2    ++     +++   ++
% red   BACKOFF_STRATEGY_CHANNEL_LOAD_AWARE      3    +++    +++   +++
% cyan  BACKOFF_STRATEGY_TARGET_PACKETLOSS       4    +      +++   +
% magen BACKOFF_STRATEGY_LEARNING                5    +++    +     +++
% black BACKOFF_STRATEGY_TARGET_DIFF_RXTX_BUSY   6    +++    ++    +++
%       BACKOFF_STRATEGY_NEIGHBOURS              7

no_nodes=unique(a(:,NO_NODES));

max_nodes=max(no_nodes);

MIN_NODE_NUM=min(a(:,NODE));

jfn_matrix = [];

tps = [];

avg_tps = {};

for ps_i = 1:size(all_ps,1)
  for cm_i = 1:size(cmodel,1)
    for tar_i = 1:size(all_targets,1)

      result_avg_tp=cell(size(no_nodes,1),size(configs,1));
      result_avg_backoff=zeros(size(no_nodes,1),size(configs,1));
      result_avg_collision=zeros(size(no_nodes,1),size(configs,1));
      
      jfn = zeros(size(no_nodes,1),size(configs,1));

      size(a)
      data=a(find((a(:,PACKETSIZE) == all_ps(ps_i)) & (a(:,CHANNELMODEL) == cmodel(cm_i)) & (a(:,TARGET) == all_targets(tar_i))), :);
      size(data)


      rep = size(unique(data(:,NUM)),1) / (size(configs,1) * size(no_nodes,1)); %repetitions
      nodes_tp = zeros(size(configs,1), size(no_nodes,1), max_nodes * rep);
      nodes_tp(:,:,:) = nan;

      for conf_i = 1:size(configs,1)

        all_nodes_data=data(find((data(:,TTQM_STRATEGY) == configs(conf_i,1)) & ...
                                 (data(:,QUEUEMAPPING) == configs(conf_i,2)) & ...
                                 (data(:,MACBOSCHEME) == configs(conf_i,3))),:);
        
        %size(all_nodes_data)

        for non_i = 1:size(no_nodes,1)
          nodes_tp_index = 1;

          nodes_data=all_nodes_data(find(all_nodes_data(:,NO_NODES) == no_nodes(non_i)), :);
          %no_nodes(non_i)
          %size(nodes_data)

          zero_bo_nodes_data=nodes_data(find((nodes_data(:,BACKOFF) == 0) & (nodes_data(:,NODE) == MIN_NODE_NUM)), :);

          SIMNUMS=unique(nodes_data(:,NUM));

          if size(nodes_data,1) ~= 0

            overall_pkts = zero_bo_nodes_data(:, PKTS_OVERALL);
            overall_tp_kbit = (8 * (all_ps(ps_i)+38) * overall_pkts) / (1024*sim_duration);
            %confidence = 1.6449 * (std(overall_tp_kbit)) / sqrt(length(overall_tp_kbit));    % 1.6449: Quantil der Standardnormalverteilung für 95%tige Sicherheit
            confidence = (std(overall_tp_kbit)) / sqrt(length(overall_tp_kbit));    % standard error

            result_avg_tp{non_i,conf_i} = [mean(overall_tp_kbit); confidence];

            result_avg_backoff(non_i,conf_i) = sum(nodes_data(:,BACKOFF).*nodes_data(:,BOUSAGE)) / sum(nodes_data(:,BOUSAGE));
            result_avg_collision(non_i, conf_i) = mean(zero_bo_nodes_data(:,COLLISIONS));

            for n = 1:size(SIMNUMS,1)
              num_zero_bo_nodes_data=zero_bo_nodes_data(find(zero_bo_nodes_data(:,NUM) == SIMNUMS(n)), :);

              tp_nodes=num_zero_bo_nodes_data(1,[PKTS_OVERALL+2:PKTS_OVERALL+no_nodes(non_i)+1]);

              jfn(non_i,conf_i)=jfn(non_i,conf_i) + (sum(tp_nodes)*sum(tp_nodes))/(sum(tp_nodes.*tp_nodes)*size(tp_nodes,2));

              nodes_tp(conf_i,non_i,[nodes_tp_index:nodes_tp_index+no_nodes(non_i)-1]) = tp_nodes;
              nodes_tp_index = nodes_tp_index + no_nodes(non_i);
            end

            jfn(non_i,conf_i) = jfn(non_i,conf_i) / size(SIMNUMS,1);

          else

            result_avg_tp{non_i,conf_i} = [0; 0];

            result_avg_backoff(non_i,conf_i) = 0;
            result_avg_collision(non_i, conf_i) = 0;

            for n = 1:size(SIMNUMS,1)
              num_zero_bo_nodes_data=zero_bo_nodes_data(find(zero_bo_nodes_data(:,NUM) == SIMNUMS(n)), :);

              tp_nodes=num_zero_bo_nodes_data(1,[PKTS_OVERALL+2:PKTS_OVERALL+no_nodes(non_i)+1]);

              jfn(non_i,conf_i)=0;

              nodes_tp(conf_i,non_i,[nodes_tp_index:nodes_tp_index+no_nodes(non_i)-1]) = 0;
              nodes_tp_index = nodes_tp_index + no_nodes(non_i);
            end

            jfn(non_i,conf_i) = 0;

          end

        end
      end


      if (all_ps(ps_i) < 1000)
        with_leading_zero = 1;
      else
        with_leading_zero = 0;
      end


      if (plot_bo == 1)
        bkoffs = [];
        h2=figure();
        for tqm_i = 1:size(configs,1)
          plot(no_nodes, result_avg_backoff(:,tqm_i), strcat(plot_cols(tqm_i)), 'LineWidth', 1.2);
          %strVals = strtrim(cellstr(num2str([round(result_avg_backoff(:,tqm_i))],'%d')));
          %text(no_nodes, result_avg_backoff(:,tqm_i), strVals, 'VerticalAlignment','top');

          %bkoffs = [bkoffs; result_avg_backoff(:, tqm_i)'];
          hold on;
        end

        %bar(bkoffs');

        title('Backoff (CWmin)');
        ylabel('Average used CWmin')
        xlabel('No. Nodes');
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'northwest');
        legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'northwest');
        grid on;
        %ylim([0 50]);
        %set(gca, 'XTick', [no_nodes(1):1:no_nodes(size(no_nodes, 1))]);
        %set(gca, 'XTick', [no_nodes]);
        set(gca, 'XTick', [2,5,10,15,20,25,30]);

        if (with_leading_zero == 1)
          fname=strcat('avg_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.png');
          saveas(h2, fname{1} ,'png');
          fname=strcat('avg_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.eps');
          saveas(h2, fname{1}, 'epsc');
        else
          fname=strcat('avg_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.png');
          saveas(h2, fname{1} ,'png');
          fname=strcat('avg_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.eps');
          saveas(h2, fname{1}, 'epsc');
        end
      end

      if (plot_sumtp == 1)
        h1=figure();
        % all_ps(ps_i) == payload size, payload size + 38 -> real pkt size
        % result_avg_tp = mean(OK Packets from measurement.log)
        % 8 for bytes to bits since pkt size is in bytes
        % 1024 to get kilobits, sim_duration to get kbit/s

        %result_avg_tp =  (8 * (all_ps(ps_i)+38) * result_avg_tp) / (1024*sim_duration);

        %avg_tp_for_max_no_nodes = result_avg_tp(size(result_avg_tp, 1),:);
        %tps = [tps; avg_tp_for_max_no_nodes];

        
        result_avg_tp_mat = cell2mat(result_avg_tp);

        size(result_avg_tp_mat)
        size(result_avg_tp)

        %avg_tps{end+1} = result_avg_tp;


        for tqm_i = 1:size(configs,1)
          tmp = result_avg_tp_mat(:, tqm_i);
          avg_tps = tmp(1:2:length(tmp));
          conf_intervals = tmp(2:2:length(tmp));
          %plot(no_nodes, result_avg_tp(:,tqm_i), plot_cols(tqm_i), 'LineWidth', 1.2);
          %bar(no_nodes, result_avg_tp(:,tqm_i));
          errorbar(no_nodes, avg_tps, conf_intervals, plot_cols(tqm_i));
          hold on;
        end
        title('Sum. Throughput');
        ylabel('Sum. Throughput (kbit/s)')
        xlabel('No. Nodes');
        ylim([800 1025]);
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'southeast');
        legend(findobj(gca,'Tag','Box'),scheme_labels, 'location', 'southeast');
        grid on;
        %set(gca, 'XTick', [no_nodes]);
        set(gca, 'XTick', [2,5,10,15,20,25,30]);

        if (with_leading_zero == 1)
          fname=strcat('sum_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.png');
          saveas(h1, fname{1} ,'png');
          fname=strcat('sum_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.eps');
          saveas(h1, fname{1}, 'epsc');
        else
          fname=strcat('sum_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.png');
          saveas(h1, fname{1} ,'png');
          fname=strcat('sum_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.eps');
          saveas(h1, fname{1}, 'epsc');
        end
      end

      if (plot_jfi == 1)
        h3=figure();
        for tqm_i = 1:size(configs,1)
          plot(no_nodes, jfn(:,tqm_i),plot_cols(tqm_i), 'LineWidth', 1.2);
          hold on;
        end
        title('Janes Fairness Index');
        ylabel('Fairness')
        xlabel('No. Nodes');
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'southeast');
        legend(findobj(gca,'Tag','Box'),scheme_labels, 'location', 'southeast');
        %ylim([0.7 1]);
        ylim([min(min(jfn))*0.95 1]);
        grid on;
        %set(gca, 'XTick', [no_nodes]);
        set(gca, 'XTick', [1,5,10,15,20,25,30]);

        if (with_leading_zero == 1)
          fname=strcat('jfi_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.png');
          saveas(h3, fname{1} ,'png');
          fname=strcat('jfi_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.eps');
          saveas(h3, fname{1}, 'epsc');
        else
          fname=strcat('jfi_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.png');
          saveas(h3, fname{1} ,'png');
          fname=strcat('jfi_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.eps');
          saveas(h3, fname{1}, 'epsc');
        end
      end

      if (plot_colls == 1)
        h4=figure();
        for tqm_i = 1:size(configs,1)
          % devide collisions by 2 because they get counted as doubles.
          % see receiver.tr for an exeperiment and eval.sh
          plot(no_nodes, result_avg_collision(:,tqm_i)/2,plot_cols(tqm_i), 'LineWidth', 1.2);
          hold on;
        end

        %bar(no_nodes, fliplr(result_avg_collision));

        title('Collisions');
        ylabel('Average collisions')
        xlabel('No. Nodes');
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'northwest');
        legend(findobj(gca,'Tag','Box'),scheme_labels,'location', 'northwest');
        grid on;
        %ylim([0 30]);
        %set(gca, 'XTick', [no_nodes(1):1:no_nodes(size(no_nodes, 1))]);
        %set(gca, 'XTick', [no_nodes]);
        set(gca, 'XTick', [2,5,10,15,20,25,30]);

        if (with_leading_zero == 1)
          fname=strcat('avg_col_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.png');
          saveas(h4, fname{1} ,'png');
          fname=strcat('avg_col_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.eps');
          saveas(h4, fname{1}, 'epsc');
        else
          fname=strcat('avg_col_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.png');
          saveas(h4, fname{1} ,'png');
          fname=strcat('avg_col_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.eps');
          saveas(h4, fname{1}, 'epsc');
        end
      end


      if (plot_nodetp == 1)
        nodes_tp_big_m = [];

        for tqm_i = 1:size(configs,1)
          %h4=figure();
          %%size(squeeze(nodes_tp(tqm_i,:,:))')
          %%size(no_nodes)
          %boxplot(squeeze(nodes_tp(tqm_i,:,:))',no_nodes);
          %hold on;
          nodes_tp_big_m = [ nodes_tp_big_m; squeeze(nodes_tp(tqm_i,:,:)) ];
          %nodes_tp_big_m = [ squeeze(nodes_tp(tqm_i,:,:)); nodes_tp_big_m ];
        end

        nodes_tp_big_m =  8 * (all_ps(ps_i)+32) * nodes_tp_big_m / (1024*sim_duration);

        nodes_tp_labes = repmat(no_nodes',1,size(configs,1));

        %size(nodes_tp_big_m)
        %size(nodes_tp_labes)
        %repmat(no_nodes',size(tqmmodes,1),1)

        nodes_tp_group_labes = reshape(repmat(tqmmodes',size(no_nodes,1),1),size(no_nodes,1)*size(tqmmodes,1),1)';
        h5=figure();
        boxplot(nodes_tp_big_m',{nodes_tp_labes,nodes_tp_group_labes},'colors',repmat(plot_cols,1,size(tqmmodes,1)),'factorgap',[10 2],'labelverbosity','minor');
        hold on;
        %tp_big_legend = legend(findobj(gca,'Tag','Box'), 'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'northeast');
        %tp_big_legend = legend(findobj(gca,'Tag','Box'), 'diff rxtx busy', 'learning', 'target packetloss', 'channelload aw.', 'max. Throughput', 'off', 'location', 'northeast');
        legend(findobj(gca,'Tag','Box'), fliplr(scheme_labels), 'location', 'northeast');

        %ylim([0 800]);
        %ylim([0 500]);
        ylim([0 1050]);
        %legend('boxon');
        title('Nodes throughput');
        ylabel('Throughput (kbit/s)')
        xlabel('No. Nodes');
        grid on;
        set(gca, 'XTick', [2,5,10,15,20,25,30]);

        if (with_leading_zero == 1)
          fname=strcat('node_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)),'.png');
          saveas(h5, fname{1} ,'png');
          fname=strcat('node_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)),'.eps');
          saveas(h5, fname{1}, 'epsc');
        else
          fname=strcat('node_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)),'.png');
          saveas(h5, fname{1} ,'png');
          fname=strcat('node_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)),'.eps');
          saveas(h5, fname{1}, 'epsc');
        end
      end

    end
  end

end


if (length(all_ps) ~= 1)
  for ii = 1:length(no_nodes)
    tps = [];

    for aa = 1:length(avg_tps)
      t = avg_tps{aa};
      tps = [tps; t(ii,:)];
    end

    nodes = int2str(no_nodes(ii));

    h6=figure();

    bar(all_ps, tps, 1.0, 'grouped');
    %set(gca, 'XDir', 'reverse');

    legend(findobj(gca,'Tag','Box'), scheme_labels, 'location', 'northeast');
    title(strcat({'Sum Throughput per Packet Size for '}, {nodes}, {' Senders'}));
    ylabel('Sum. Throughput (kbit/s)')
    xlabel('Packet Size');
    ylim([0 1000]);
    grid on;

    saveas(h6, strcat('ps_tp_', nodes, '.png'), 'png');
    saveas(h6, strcat('ps_tp_', nodes, '.eps'), 'epsc');

  end
end

