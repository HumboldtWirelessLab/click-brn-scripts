function interference_eval(matfile)

% seq node_a node_b rx_node ID_of_chan_stats
% flow_rate flow_queue_empty channel hw_busy hwrx
% hwtx mac_busy mac_rx mac_tx mode_id

STAGE=15;

%scrsz = get(0,'ScreenSize');
scrsz = [ 1 1 800 600 ];
figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
set(gcf,'paperpositionmode','auto');
set(gca,'fontsize',16);

result=load(matfile,'-ASCII');

nodes=unique(result(:,2));

%Stats of tx node
prestats_mac=zeros(size(nodes,1),3); %busy rx tx 
prestats_hw=zeros(size(nodes,1),3);

rates=zeros(size(nodes,1),1);

durstats_mac=zeros(size(nodes,1),3);
durstats_hw=zeros(size(nodes,1),3);

poststats_mac=zeros(size(nodes,1),3);
poststats_hw=zeros(size(nodes,1),3);

%stats of rx node

pre_rx_nodes_hw = zeros((size(nodes,1)-1)*size(nodes,1) ,3);
pre_rx_nodes_mac = zeros((size(nodes,1)-1)*size(nodes,1) ,3);

dur_rx_nodes_hw = zeros((size(nodes,1)-1)*size(nodes,1) ,3);
dur_rx_nodes_mac = zeros((size(nodes,1)-1)*size(nodes,1) ,3);

post_rx_nodes_hw = zeros((size(nodes,1)-1)*size(nodes,1) ,3);
post_rx_nodes_mac = zeros((size(nodes,1)-1)*size(nodes,1) ,3);

rx_nodes_index=0;

for i = 1:size(nodes,1)
   node=nodes(i);

   nodes_result=result(find((result(:,2) == node) & (result(:,4) == node)),:);
   rx_nodes_result=result(find((result(:,2) == node) & (result(:,4) ~= node)),:);
      
   prestats_hw(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==1),[9 10 11]));
   prestats_mac(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==1),[ 12 13 14]));

   durstats_hw(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==2),[9 10 11]));
   durstats_mac(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==2),[ 12 13 14]));

   rates(i,1) = mean(nodes_result(find(nodes_result(:,STAGE)==4),6))/1024;
  
   poststats_hw(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==4),[9 10 11]));
   poststats_mac(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==4),[ 12 13 14]));

   rx_nodes = unique(rx_nodes_result(:,4));

   for r = 1:size(rx_nodes,1)
     rx_node = rx_nodes(r);
   
     rx_node_result = rx_nodes_result(find(rx_nodes_result(:,4) == rx_node),:);
     pre_rx_node_hw(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==1),[9 10 11])); 
     pre_rx_node_mac(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==1),[ 12 13 14]));
     
     dur_rx_nodes_hw(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==2),[9 10 11]));
     dur_rx_nodes_mac(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==2),[ 12 13 14]));
         
     post_rx_node_hw(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==4),[9 10 11])); 
     post_rx_node_mac(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==4),[ 12 13 14]));
      
   end

   rx_nodes_index = rx_nodes_index + size(rx_nodes,1);

end
size(post_rx_nodes_hw )
rx_nodes_index

prestats_diff = prestats_hw - prestats_mac;
durstats_diff = durstats_hw - durstats_mac;
poststats_diff = poststats_hw - poststats_mac;


subplot(3,2,1);
plot(prestats_hw(:,1),rates(:,1),'o');
grid on;
xlabel('HW-Busy');
ylabel('Throughtput kbits/s');
title('HW-Busy vs max. Throughput');


subplot(3,2,2);
plot(prestats_mac(:,1),rates(:,1),'o');
grid on;
xlabel('MAC-Busy');
ylabel('Throughtput kbits/s');
title('MAC-Busy vs max. Throughput');

subplot(3,2,3);
max_value=(ceil(max(max(prestats_hw(:,1)),max(poststats_hw(:,1)))/10) + 1) *10;
scatter(prestats_hw(:,1),poststats_hw(:,1)); 
grid on;
xlabel('HW-Busy before measurement (%)');
ylabel('HW-Busy after measurement (%)');
title('HW-Busy before and after measurement');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);


subplot(3,2,4);
max_value=(ceil(max(max(prestats_mac(:,1)),max(prestats_hw(:,1)))/10) + 1) *10;
scatter(prestats_mac(:,1),prestats_hw(:,1));
grid on;
xlabel('mac-busy');
ylabel('hw-busy');
title('tx nodes before measurement');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);


subplot(3,2,5);
max_value=(ceil(max(max(dur_rx_nodes_mac(:,1)),max(dur_rx_nodes_hw(:,1)))/10) + 1) *10;
scatter(dur_rx_nodes_mac(:,1),dur_rx_nodes_hw(:,1));
grid on;
xlabel('mac-busy');
ylabel('hw-busy');
title('rx nodes measurement');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);


%all nodes before measurement

subplot(3,2,5);
max_value=(ceil(max(max(pre_rx_nodes_mac(:,1)),max(pre_rx_nodes_hw(:,1)))/10) + 1) *10;
scatter(pre_rx_nodes_mac(:,1),pre_rx_nodes_hw(:,1));
grid on;
xlabel('mac-busy');
ylabel('hw-busy');
title('pre rx nodes measurement');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);

end
