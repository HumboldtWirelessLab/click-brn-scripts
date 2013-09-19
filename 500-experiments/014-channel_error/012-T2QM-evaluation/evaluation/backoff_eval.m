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
COLLISIONS=38;

cm_string={'real';'shadowing';'tworay'};
target_string={'bcast';'unicast'};
tqm_string={ 'off';'on'};
%ps_string={'300', '500', '800', '1100', '1500'};
ps_string={'1500'};



print=1;
a=load('backoffusage.mat','-ASCII');
%a=load('backoffusage_20130606.mat','-ASCII');

all_ps=unique(a(:,PACKETSIZE));
cmodel=unique(a(:,CHANNELMODEL));
%cmodel=[1];
all_targets=unique(a(:,TARGET));
all_targets=[1];
tqmmodes=unique(a(:,TTQM_STRATEGY));

%plot_cols=['b';'g';'r';'c';'m';'k'];
%tqmmodes=[0 2 3 4 5 6]';

plot_cols=['b';'r';'m'];
tqmmodes=[0 3 5]';


%                                                     TP     FAIR  Backoff
% blue  BACKOFF_STRATEGY_OFF                     0    +      +++   +++
%       BACKOFF_STRATEGY_DIRECT                  1
% green BACKOFF_STRATEGY_MAX_THROUGHPUT          2    ++     +++   ++
% red   BACKOFF_STRATEGY_CHANNEL_LOAD_AWARE      3    +++    +++   +++
% cyan  BACKOFF_STRATEGY_TARGET_PACKETLOSS       4    +      +++   +
% magen BACKOFF_STRATEGY_LEARNING                5    +++    +     +++
% black BACKOFF_STRATEGY_TARGET_DIFF_RXTX_BUSY   6    +++    ++    +++

no_nodes=unique(a(:,NO_NODES));

max_nodes=max(no_nodes);

MIN_NODE_NUM=min(a(:,NODE));

min_bo = min(a(:,BACKOFF));

jfn_matrix = [];


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

      %nodes_tp
      
      plot_all=1;
      if ( plot_all == 1 )
          
        h1=figure();
        result_avg_tp =  8 * all_ps(ps_i) * result_avg_tp / (1024*30);
        for tqm_i = 1:size(tqmmodes,1)
          plot(no_nodes, result_avg_tp(:,tqm_i),plot_cols(tqm_i));
          hold on;
        end
        title('Sum. Throughput');
        ylabel('sum. throughput (kbit/s)')
        xlabel('No. Nodes');
        ylim([0 1000]);
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'southeast');
        legend(findobj(gca,'Tag','Box'),'off','channelload aw.','learning', 'location', 'southeast');
        grid on;

        
        
        fname=strcat('tp_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.png');
        saveas(h1, fname{1} ,'png');
        fname=strcat('tp_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.eps');
        saveas(h1, fname{1}, 'eps');

        h2=figure();
        for tqm_i = 1:size(tqmmodes,1)
          plot(no_nodes, result_avg_backoff(:,tqm_i),plot_cols(tqm_i));
          hold on;
        end
        title('Backoff');
        ylabel('Avg. used backoff')
        xlabel('No. Nodes');
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'northwest');
        legend(findobj(gca,'Tag','Box'),'off','channelload aw.','learning','location', 'northwest');
        grid on;
        %ylim([0 30]);

        fname=strcat('bo_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.png');
        saveas(h2, fname{1} ,'png');
        fname=strcat('bo_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.eps');
        saveas(h2, fname{1}, 'eps');

        h3=figure();
        for tqm_i = 1:size(tqmmodes,1)
          plot(no_nodes, jfn(:,tqm_i),plot_cols(tqm_i));
          hold on;
        end
        title('Janes Fairness Index');
        ylabel('Fairness')
        xlabel('No. Nodes');
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'southeast');
        legend(findobj(gca,'Tag','Box'),'off','channelload aw.','learning', 'location', 'southeast');
        ylim([0 1]);
        grid on;

        fname=strcat('jfi_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.png');
        saveas(h3, fname{1} ,'png');
        fname=strcat('jfi_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.eps');
        saveas(h3, fname{1}, 'eps');
        
        h4=figure();
        for tqm_i = 1:size(tqmmodes,1)
          plot(no_nodes, result_avg_collision(:,tqm_i),plot_cols(tqm_i));
          hold on;
        end
        title('Collisions');
        ylabel('Avg. collisions')
        xlabel('No. Nodes');
        %legend(findobj(gca,'Tag','Box'),'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'northwest');
        legend(findobj(gca,'Tag','Box'),'off','channelload aw.','learning','location', 'northwest');
        grid on;
        %ylim([0 30]);
        
        fname=strcat('col_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.png');
        saveas(h4, fname{1} ,'png');
        fname=strcat('col_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',ps_string(ps_i), '.eps');
        saveas(h4, fname{1}, 'eps');
        
        
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

      nodes_tp_big_m =  8 * all_ps(ps_i) * nodes_tp_big_m / (1024*30);

      nodes_tp_labes = repmat(no_nodes',1,size(tqmmodes,1));

      %size(nodes_tp_big_m)
      %size(nodes_tp_labes)
      %repmat(no_nodes',size(tqmmodes,1),1)

      if ( plot_all == 1 )
        nodes_tp_group_labes = reshape(repmat(tqmmodes',size(no_nodes,1),1),size(no_nodes,1)*size(tqmmodes,1),1)'
        h4=figure();
        boxplot(nodes_tp_big_m',{nodes_tp_labes,nodes_tp_group_labes},'colors',repmat(plot_cols,1,size(tqmmodes,1)),'factorgap',[10 2],'labelverbosity','minor');
        hold on;
        %tp_big_legend = legend(findobj(gca,'Tag','Box'), 'off','max. Throughput','channelload aw.','target packetloss','learning','diff rxtx busy', 'location', 'northeast');
        %tp_big_legend = legend(findobj(gca,'Tag','Box'), 'diff rxtx busy', 'learning', 'target packetloss', 'channelload aw.', 'max. Throughput', 'off', 'location', 'northeast');
        tp_big_legend = legend(findobj(gca,'Tag','Box'), 'learning', 'channelload aw.','off', 'location', 'northeast');

        ylim([0 800]);
        %legend('boxon');
        title('Nodes throughput');
        ylabel('throughput (kbit/s)')
        xlabel('No. Nodes/Algorithm');
        grid on;

        fname=strcat('bptp_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'.png');
        saveas(h4, fname{1} ,'png');
        fname=strcat('bptp_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'.eps');
        saveas(h4, fname{1}, 'eps');
      end
    end
  end

end

