NUM=1;
NO_NODES=2;
PACKETSIZE=3;
TTQM_STRATEGY=4;
RATE=5;
TARGET=6;
CHANNELMODEL=7;
NODE=8;
BACKOFF=9;
BOUSAGE=10;
BOEXP=11;
PKTS_OVERALL=12;
%COLLISIONS=38;
COLLISIONS=63;

cm_string={'real';'shadow';'2ray'};
target_string={'bcast';'ucast'};
tqm_string={ 'off';'on'};
%ps_string={'200', '400', '800', '1200', '1500'};
ps_string={'1500'};
%ps_string={'750', '1500'};
%ps_string={'500', '1000', '1500'};
%ps_string={'100', '200', '400', '800', '1250', '1500'};
%ps_string={'200', '800', '1500'};
%ps_string={'375', '750', '1500'};


sim_duration = 30;

print=1;
a=load('backoffusage.mat','-ASCII');
%a=load('backoffusage_20130606.mat','-ASCII');

all_ps=unique(a(:,PACKETSIZE));
cmodel=unique(a(:,CHANNELMODEL));
%cmodel=[1];
%all_targets=unique(a(:,TARGET));
all_targets=[1];
tqmmodes=unique(a(:,TTQM_STRATEGY));

%plot_cols=['b';'g';'r';'c';'k';'m';'y'];
%tqmmodes=[2 3 4 5 7 8 9]';

%plot_cols=['b';'r';'m';'g';'c'];
%tqmmodes=[2 3 4 8 9]';

%plot_cols=['b';'r';'g';'m'];
%tqmmodes=[8 3 5 9]';

plot_cols=['b';'r';'m'];
tqmmodes=[8 3 5]';

%plot_cols=['b';'r'];
%tqmmodes=[8 5]';

%plot_cols=['b'];
%tqmmodes=[0];

schemes = {'old 802.11','direct','max. tp','busy aware','target pkt loss','learning','target diff rx tx busy','neighbours','802.11','tx aware'};

scheme_labels = {};

for ii = 1:size(tqmmodes, 1)
  scheme_labels = union(scheme_labels, schemes{tqmmodes(ii)+1}, 'stable');
end

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

min_bo = min(a(:,BACKOFF));

jfn_matrix = [];

tps = [];

avg_tps = {};

for ps_i = 1:size(all_ps,1)
  for cm_i = 1:size(cmodel,1)
    for tar_i = 1:size(all_targets,1)

      result_avg_tp=zeros(size(no_nodes,1),size(tqmmodes,1));
      result_avg_backoff=zeros(size(no_nodes,1),size(tqmmodes,1));
      jfn = zeros(size(no_nodes,1),size(tqmmodes,1));

      data=a(find((a(:,PACKETSIZE) == all_ps(ps_i)) & (a(:,CHANNELMODEL) == cmodel(cm_i)) & (a(:,TARGET) == all_targets(tar_i))), :);
      %size(data);


      rep = size(unique(data(:,NUM)),1) / (size(tqmmodes,1) * size(no_nodes,1)); %repetitions
      nodes_tp = zeros(size(tqmmodes,1), size(no_nodes,1), max_nodes * rep);
      nodes_tp(:,:) = nan;

      for tqm_i = 1:size(tqmmodes,1)

        for non_i = 1:size(no_nodes,1)
          nodes_tp_index = 1;
          nodes_data=data(find((data(:,TTQM_STRATEGY) == tqmmodes(tqm_i)) & (data(:,NO_NODES) == no_nodes(non_i))), :);

          zero_bo_nodes_data=nodes_data(find((nodes_data(:,BACKOFF) == 0) & (nodes_data(:,NODE) == MIN_NODE_NUM)), :);
          SIMNUMS=unique(nodes_data(:,NUM));

          result_avg_tp(non_i,tqm_i) = mean(zero_bo_nodes_data(:,PKTS_OVERALL));
          result_avg_backoff(non_i,tqm_i) = sum(nodes_data(:,BACKOFF).*nodes_data(:,BOUSAGE)) / sum(nodes_data(:,BOUSAGE));
          result_avg_collision(non_i, tqm_i) = mean(zero_bo_nodes_data(:,COLLISIONS));

          for n = 1:size(SIMNUMS,1)
            num_zero_bo_nodes_data=zero_bo_nodes_data(find(zero_bo_nodes_data(:,NUM) == SIMNUMS(n)), :);

            tp_nodes=num_zero_bo_nodes_data(1,[PKTS_OVERALL+2:PKTS_OVERALL+no_nodes(non_i)+1]);

            jfn(non_i,tqm_i)=jfn(non_i,tqm_i) + (sum(tp_nodes)*sum(tp_nodes))/(sum(tp_nodes.*tp_nodes)*size(tp_nodes,2));

            nodes_tp(tqm_i,non_i,[nodes_tp_index:nodes_tp_index+no_nodes(non_i)-1]) = tp_nodes;
            nodes_tp_index = nodes_tp_index + no_nodes(non_i);
          end

          jfn(non_i,tqm_i) = jfn(non_i,tqm_i) / size(SIMNUMS,1);

        end
      end


      if (all_ps(ps_i) < 1000)
        with_leading_zero = 1;
      else
        with_leading_zero = 0;
      end


      plot_all=1;
      if ( plot_all == 1 )

        bkoffs = [];

        h2=figure();
        for tqm_i = 1:size(tqmmodes,1)
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
        set(gca, 'XTick', [no_nodes]);

        if (with_leading_zero == 1)
          fname=strcat('avg_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i), '.png');
          saveas(h2, fname{1} ,'png');
          fname=strcat('avg_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i), '.eps');
          saveas(h2, fname{1}, 'epsc');
        else
          fname=strcat('avg_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.png');
          saveas(h2, fname{1} ,'png');
          fname=strcat('avg_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.eps');
          saveas(h2, fname{1}, 'epsc');
        end


        h1=figure();
        % all_ps(ps_i) == payload size, payload size + 38 -> real pkt size
        % result_avg_tp = mean(OK Packets from measurement.log)
        % 8 for bytes to bits since pkt size is in bytes
        % 1024 to get kilobits, sim_duration to get kbit/s
        result_avg_tp =  8 * (all_ps(ps_i)+38) * result_avg_tp / (1024*sim_duration);


        %avg_tp_for_max_no_nodes = result_avg_tp(size(result_avg_tp, 1),:);
        %tps = [tps; avg_tp_for_max_no_nodes];


        avg_tps{end+1} = result_avg_tp;


        for tqm_i = 1:size(tqmmodes,1)
          plot(no_nodes, result_avg_tp(:,tqm_i), plot_cols(tqm_i), 'LineWidth', 1.2);
          %bar(no_nodes, result_avg_tp(:,tqm_i));
          hold on;
        end
        title('Sum. Throughput');
        ylabel('sum. Throughput (kbit/s)')
        xlabel('No. Nodes');
        ylim([0 1000]);
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'southeast');
        legend(findobj(gca,'Tag','Box'),scheme_labels, 'location', 'southeast');
        grid on;
        set(gca, 'XTick', [no_nodes]);

        if (with_leading_zero == 1)
          fname=strcat('sum_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i), '.png');
          saveas(h1, fname{1} ,'png');
          fname=strcat('sum_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i), '.eps');
          saveas(h1, fname{1}, 'epsc');
        else
          fname=strcat('sum_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.png');
          saveas(h1, fname{1} ,'png');
          fname=strcat('sum_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.eps');
          saveas(h1, fname{1}, 'epsc');
        end

        h3=figure();
        for tqm_i = 1:size(tqmmodes,1)
          plot(no_nodes, jfn(:,tqm_i),plot_cols(tqm_i), 'LineWidth', 1.2);
          hold on;
        end
        title('Janes Fairness Index');
        ylabel('Fairness')
        xlabel('No. Nodes');
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'southeast');
        legend(findobj(gca,'Tag','Box'),scheme_labels, 'location', 'southeast');
        ylim([0 1]);
        grid on;
        set(gca, 'XTick', [no_nodes]);

        if (with_leading_zero == 1)
          fname=strcat('jfi_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i), '.png');
          saveas(h3, fname{1} ,'png');
          fname=strcat('jfi_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i), '.eps');
          saveas(h3, fname{1}, 'epsc');
        else
          fname=strcat('jfi_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.png');
          saveas(h3, fname{1} ,'png');
          fname=strcat('jfi_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.eps');
          saveas(h3, fname{1}, 'epsc');
        end



        h4=figure();
        for tqm_i = 1:size(tqmmodes,1)
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
        set(gca, 'XTick', [no_nodes]);

        if (with_leading_zero == 1)
          fname=strcat('avg_col_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i), '.png');
          saveas(h4, fname{1} ,'png');
          fname=strcat('avg_col_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i), '.eps');
          saveas(h4, fname{1}, 'epsc');
        else
          fname=strcat('avg_col_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.png');
          saveas(h4, fname{1} ,'png');
          fname=strcat('avg_col_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.eps');
          saveas(h4, fname{1}, 'epsc');
        end

      end


      nodes_tp_big_m = [];

      for tqm_i = 1:size(tqmmodes,1)
        %h4=figure();
        %%size(squeeze(nodes_tp(tqm_i,:,:))')
        %%size(no_nodes)
        %boxplot(squeeze(nodes_tp(tqm_i,:,:))',no_nodes);
        %hold on;
        nodes_tp_big_m = [ nodes_tp_big_m; squeeze(nodes_tp(tqm_i,:,:)) ];
        %nodes_tp_big_m = [ squeeze(nodes_tp(tqm_i,:,:)); nodes_tp_big_m ];
      end

      nodes_tp_big_m =  8 * (all_ps(ps_i)+32) * nodes_tp_big_m / (1024*sim_duration);

      nodes_tp_labes = repmat(no_nodes',1,size(tqmmodes,1));

      %size(nodes_tp_big_m)
      %size(nodes_tp_labes)
      %repmat(no_nodes',size(tqmmodes,1),1)

      if ( plot_all == 1 )
        nodes_tp_group_labes = reshape(repmat(tqmmodes',size(no_nodes,1),1),size(no_nodes,1)*size(tqmmodes,1),1)';
        h5=figure();
        boxplot(nodes_tp_big_m',{nodes_tp_labes,nodes_tp_group_labes},'colors',repmat(plot_cols,1,size(tqmmodes,1)),'factorgap',[10 2],'labelverbosity','minor');
        hold on;
        %tp_big_legend = legend(findobj(gca,'Tag','Box'), 'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'northeast');
        %tp_big_legend = legend(findobj(gca,'Tag','Box'), 'diff rxtx busy', 'learning', 'target packetloss', 'channelload aw.', 'max. Throughput', 'off', 'location', 'northeast');
        legend(findobj(gca,'Tag','Box'), fliplr(scheme_labels), 'location', 'northeast');

        %ylim([0 800]);
        %legend('boxon');
        title('Nodes throughput');
        ylabel('Throughput (kbit/s)')
        xlabel('No. Nodes');
        grid on;

        if (with_leading_zero == 1)
          fname=strcat('node_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i),'.png');
          saveas(h5, fname{1} ,'png');
          fname=strcat('node_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',ps_string(ps_i),'.eps');
          saveas(h5, fname{1}, 'epsc');
        else
          fname=strcat('node_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i),'.png');
          saveas(h5, fname{1} ,'png');
          fname=strcat('node_tp_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i),'.eps');
          saveas(h5, fname{1}, 'epsc');
        end

      end
    end
  end

end

foo = 1;
if (foo == 1)
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

