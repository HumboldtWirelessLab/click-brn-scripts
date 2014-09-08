NUM=1;
NO_NODES=2;
PACKETSIZE=3;
TTQM_STRATEGY=4;
RATE=5;
TARGET=6;
CHANNELMODEL=7;
QUEUEMAPPING=8;
MACBOSCHEME=9;
FIXEDBO=10;

PKTS_OVERALL=11;

COLLISIONS=62;

cm_string={'real';'shadowing';'2ray'};
target_string={'bcast';'ucast'};
tqm_string={ 'off';'on'};

sim_duration = 60;

print=1;
if ( ~(exist('a','var') ))
  disp('load data...')
  a=load('backoffperformance.mat','-ASCII');
  %a=load('2014-08-07-shad/backoffusage.mat','-ASCII');
end

all_ps=unique(a(:,PACKETSIZE));
cmodel=unique(a(:,CHANNELMODEL));
configs=unique(a(:,[TTQM_STRATEGY QUEUEMAPPING MACBOSCHEME]),'rows')

bo_size=unique(a(:,FIXEDBO));

configs=configs(find((configs(:,2)==2) ),:) %prob

tqmmodes=unique(configs(:,1));

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

no_nodes=unique(a(:,NO_NODES));

no_nodes_label = {};
for ii = 1:size(no_nodes,1)
  no_nodes_label = union(no_nodes_label, strcat(num2str(no_nodes(ii)), ' nodes'), 'stable');
end

plot_bo = 1;

max_nodes=max(no_nodes);

tps = [];

avg_tps = {};

for ps_i = 1:size(all_ps,1)
  for cm_i = 1:size(cmodel,1)
    for tar_i = 1:size(all_targets,1)

      %size(a)
      data=a(find((a(:,PACKETSIZE) == all_ps(ps_i)) & (a(:,CHANNELMODEL) == cmodel(cm_i)) & (a(:,TARGET) == all_targets(tar_i))), :);
      %size(data)

      % conf_id no_nodes bo tp tp_conf
      tp_result=[];
      bo_max_tp_result=[];

      tmp_tp_result=zeros(size(bo_size,1),5);

      RES_CONF_ID=1;
      RES_NONODES=2;
      RES_BO=3;
      RES_TP=4;
      RES_TP_CONF=5;

      rep = size(unique(data(:,NUM)),1) / (size(configs,1) * size(no_nodes,1) * size(bo_size,1)); %repetitions

      for conf_i = 1:size(configs,1)

        all_nodes_data=data(find((data(:,TTQM_STRATEGY) == configs(conf_i,1)) & ...
                                 (data(:,QUEUEMAPPING) == configs(conf_i,2)) & ...
                                 (data(:,MACBOSCHEME) == configs(conf_i,3))),:);

        %size(all_nodes_data)

        for non_i = 1:size(no_nodes,1)
          nodes_tp_index = 1;

          nodes_data=all_nodes_data(find(all_nodes_data(:,NO_NODES) == no_nodes(non_i)), :);

          zero_bo_nodes_data=nodes_data;%(find((nodes_data(:,BACKOFF) == 0) & (nodes_data(:,NODE) == MIN_NODE_NUM)), :);
          
          %size(zero_bo_nodes_data)

          SIMNUMS=unique(nodes_data(:,NUM));
                 
          if size(nodes_data,1) ~= 0
      
            tp_result_index=1;

            for bo_i = 1:size(bo_size,1)

              bo_data = zero_bo_nodes_data(zero_bo_nodes_data(:,FIXEDBO) == bo_size(bo_i),:);
              
              overall_pkts = bo_data(:, PKTS_OVERALL);
              overall_tp_kbit = (8 * (all_ps(ps_i)+38) * overall_pkts) / (1024*sim_duration);
              %confidence = 1.6449 * (std(overall_tp_kbit)) / sqrt(length(overall_tp_kbit));    % 1.6449: Quantil der Standardnormalverteilung für 95%tige Sicherheit
              confidence = (std(overall_tp_kbit)) / sqrt(length(overall_tp_kbit));    % standard error

              tmp_tp_result(tp_result_index,:) = [conf_i no_nodes(non_i) bo_size(bo_i) mean(overall_tp_kbit) confidence];

              tp_result_index=tp_result_index+1;
            end
               
            tp_result = [ tp_result; tmp_tp_result];
            
            tmp_tp_result_sort=sortrows(tmp_tp_result(2:end,:),RES_TP);
            max_tp_bo=tmp_tp_result_sort(end,RES_BO);
            bo_max_tp_result = [ bo_max_tp_result; [conf_i no_nodes(non_i) max_tp_bo]];

          end

        end
      end

      tp_result
      
      if (plot_bo == 1)
      
        for conf_i = 1:size(configs,1)

          h2=figure();
            
          for non_i = 1:size(no_nodes,1)
            plot_res = tp_result(find((tp_result(:,RES_CONF_ID) == conf_i) & (tp_result(:,RES_NONODES) == no_nodes(non_i))),:);
            plot(plot_res(:,RES_BO), plot_res(:,RES_TP), strcat(plot_cols(non_i)), 'LineWidth', 1.2);
         
            hold on;
          end
        end

        %bar(bkoffs');

        title('BO vs. Throughput');
        ylabel('Throughput in kbits/s')
        xlabel('Backoff');
        legend(findobj(gca,'Tag','Box'),no_nodes_label,'location', 'southwest');
        grid on;
        %set(gca, 'XTick', [2,5,10,15,20,25,30]);

        if (all_ps(ps_i) < 1000)
          fname=strcat('tp_per_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.png');
          saveas(h2, fname{1} ,'png');
          fname=strcat('tp_per_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.eps');
          saveas(h2, fname{1}, 'epsc');
        else
          fname=strcat('tp_per_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.png');
          saveas(h2, fname{1} ,'png');
          fname=strcat('tp_per_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.eps');
          saveas(h2, fname{1}, 'epsc');
        end
        
        for conf_i = 1:size(configs,1)

          h2=figure();
            
          plot_res = bo_max_tp_result(find((bo_max_tp_result(:,RES_CONF_ID) == conf_i)),:);
          plot(plot_res(:,2), plot_res(:,3), strcat(plot_cols(conf_i)), 'LineWidth', 1.2);
         
        end

        %bar(bkoffs');

        title('BO with max. throughput');
        ylabel('Backoff')
        xlabel('#nodes');
        %legend(findobj(gca,'Tag','Box'),no_nodes_label,'location', 'southwest');
        grid on;
        ylim([0 max(bo_max_tp_result(:,3))*1.1]);
        %set(gca, 'XTick', [2,5,10,15,20,25,30]);

        if (all_ps(ps_i) < 1000)
          fname=strcat('bo_max_tp_per_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.png');
          saveas(h2, fname{1} ,'png');
          fname=strcat('bo_max_tp_per_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_0',num2str(all_ps(ps_i)), '.eps');
          saveas(h2, fname{1}, 'epsc');
        else
          fname=strcat('bo_max_tp_per_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.png');
          saveas(h2, fname{1} ,'png');
          fname=strcat('bo_max_tp_per_bo_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'_ps_',num2str(all_ps(ps_i)), '.eps');
          saveas(h2, fname{1}, 'epsc');
        end
        
      end

    end
  end
end
