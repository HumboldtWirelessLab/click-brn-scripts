function interference_eval(matfile,prefix_name)

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

%some checks
channels=unique(result(:,8));

if ( size(channels,1) ~= 1 )
   disp('more than one channel. Not good.'); 
end


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
dur_rx_nodes_mac = zeros((size(nodes,1)-1)*size(nodes,1) ,4);
dur_rx_nodes_noise = zeros((size(nodes,1)-1)*size(nodes,1) ,1);
dur_rx_nodes_crc = zeros((size(nodes,1)-1)*size(nodes,1) ,1);
dur_rx_nodes_phy = zeros((size(nodes,1)-1)*size(nodes,1) ,1);
dur_rx_nodes_sysload = zeros((size(nodes,1)-1)*size(nodes,1) ,1);

post_rx_nodes_hw = zeros((size(nodes,1)-1)*size(nodes,1) ,3);
post_rx_nodes_mac = zeros((size(nodes,1)-1)*size(nodes,1) ,3);

pre_all_nodes_hw = zeros(size(nodes,1) ,3);
pre_all_nodes_mac = zeros(size(nodes,1) ,3);

rx_nodes_index=0;

for i = 1:size(nodes,1)
  node=nodes(i);

  nodes_result=result(find((result(:,2) == node) & (result(:,4) == node)),:);
  rx_nodes_result=result(find((result(:,2) == node) & (result(:,4) ~= node)),:);
  all_nodes_result=result(find(result(:,2) == node),:);
      
  prestats_hw(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==1),[9 10 11]),1);
  prestats_mac(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==1),[ 12 13 14]),1);

  durstats_hw(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==2),[9 10 11]),1);
  durstats_mac(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==2),[ 12 13 14]),1);

  rates(i,1) = mean(nodes_result(find(nodes_result(:,STAGE)==4),6),1)/1024;
  
  poststats_hw(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==4),[9 10 11]),1);
  poststats_mac(i,:) = mean(nodes_result(find(nodes_result(:,STAGE)==4),[ 12 13 14]),1);

  rx_nodes = unique(rx_nodes_result(:,4));

  for r = 1:size(rx_nodes,1)
    rx_node = rx_nodes(r);
   
    rx_node_result = rx_nodes_result(find(rx_nodes_result(:,4) == rx_node),:);
    
    %mean(x,1) -> number of col will be the same; mean only over cols
    pre_rx_nodes_hw(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==1),[9 10 11]),1); 
    pre_rx_nodes_mac(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==1),[ 12 13 14]),1);
     
    dur_rx_nodes_hw(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==2),[9 10 11]),1);
    dur_rx_nodes_mac(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==2),[ 12 13 14 18]),1);
    
    dur_rx_nodes_noise(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==2),[16]),1);
    dur_rx_nodes_crc(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==2),[17]),1);
    dur_rx_nodes_phy(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==2),[19]),1);
    dur_rx_nodes_sysload(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==2),[20]),1);
         
    post_rx_node_hw(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==4),[9 10 11]),1); 
    post_rx_node_mac(rx_nodes_index+r,:) = mean(rx_node_result(find(rx_node_result(:,STAGE)==4),[ 12 13 14]),1);
      
  end

  rx_nodes_index = rx_nodes_index + size(rx_nodes,1);

  for pre_n = 1:size(nodes,1)
    pre_node = nodes(pre_n);
      
    pre_node_result = all_nodes_result(find((all_nodes_result(:,STAGE)==1) & (all_nodes_result(:,4)==pre_node)),:);
    pre_all_nodes_hw(pre_node,:) = pre_all_nodes_hw(pre_node,:) + mean(pre_node_result(:,[9 10 11]),1);
    pre_all_nodes_mac(pre_node,:) = pre_all_nodes_mac(pre_node,:) + mean(pre_node_result(:,[12 13 14]),1);
  end
      
end

pre_all_nodes_hw = pre_all_nodes_hw / size(nodes,1);
pre_all_nodes_mac = pre_all_nodes_mac / size(nodes,1);

prestats_diff = prestats_hw - prestats_mac;
durstats_diff = durstats_hw - durstats_mac;
poststats_diff = poststats_hw - poststats_mac;

dur_rx_nodes_mac_hw_diff = dur_rx_nodes_hw -  dur_rx_nodes_mac(:,[1 2 3]);

X_PLOT_SIZE=3;
Y_PLOT_SIZE=5;

%--------------------------------------------------------------------------

clf;
plot(prestats_hw(:,1),rates(:,1),'o');
grid on;
title('Channel busy (NIC-based) vs. max. Throughput','FontSize',18);
ylabel('Throughtput (kbits/s)','FontSize',18);
xlabel('Channel busy (NIC-based)','FontSize',18);
set(gca,'FontSize',14);

print('-deps2c', strcat( prefix_name, '_nic_vs_tp.eps'));

clf;
plot(prestats_mac(:,1),rates(:,1),'o');
grid on;
title('Channel busy (trace-based) vs. max. Throughput','FontSize',18);
ylabel('Throughtput (kbits/s)','FontSize',18);
xlabel('Channel busy (trace-based)','FontSize',18);
set(gca,'FontSize',14);

print('-deps2c', strcat( prefix_name, '_mac_vs_tp.eps'));

clf;
max_value=min(100,(ceil(max(max(pre_all_nodes_mac(:,1)),max(pre_all_nodes_hw(:,1)))/10) + 1) *10);
scatter(pre_all_nodes_mac(:,1),pre_all_nodes_hw(:,1));

grid on;
xlabel('Channel busy (trace-based)','FontSize',18);
ylabel('Channel busy (NIC-based)','FontSize',18);
title('Channel busy (Trace-based vs. NIC-based)','FontSize',18);

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);
set(gca,'FontSize',14);

print('-deps2c', strcat( prefix_name, '_mac_vs_nic.eps'));

clf;
max_value=min(100,(ceil(max(max(dur_rx_nodes_mac(:,1)),max(dur_rx_nodes_hw(:,1)))/10) + 1) *10);
scatter(dur_rx_nodes_mac(:,1),dur_rx_nodes_hw(:,1));

grid on;
xlabel('Channel busy (trace-based)','FontSize',18);
ylabel('Channel busy (NIC-based)','FontSize',18);
title('Channel busy (Trace-based vs. NIC-based)','FontSize',18);

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);
set(gca,'FontSize',14);

print('-deps2c', strcat( prefix_name, '_mac_vs_nic_meas.eps'));

clf;
max_value=min(100,(ceil(max(max(dur_rx_nodes_mac(:,4)),max(dur_rx_nodes_hw(:,1)))/10) + 1) *10);
scatter(dur_rx_nodes_mac(:,4),dur_rx_nodes_hw(:,1));

grid on;
xlabel('Channel busy w/o erroneous packets (trace-based)','FontSize',18);
ylabel('Channel busy (NIC-based)','FontSize',18);
title('Channel busy (Trace-based (w/o errors) vs. NIC-based)','FontSize',18);

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);
set(gca,'FontSize',14);

print('-deps2c', strcat( prefix_name, '_mac_no_err_vs_nic_meas.eps'));


%--------------------------------------------------------------------------


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
plot(prestats_hw(:,1),rates(:,1),'o');
grid on;
xlabel('HW-Busy');
ylabel('Throughtput kbits/s');
title(strcat('HW-Busy vs max. Throughput (',num2str(channels(1)),')'));


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,2);
plot(prestats_mac(:,1),rates(:,1),'o');
grid on;
xlabel('MAC-Busy');
ylabel('Throughtput kbits/s');
title('MAC-Busy vs max. Throughput');

subplot(Y_PLOT_SIZE,X_PLOT_SIZE,3);
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


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,4);
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

%all nodes before measurement

subplot(Y_PLOT_SIZE,X_PLOT_SIZE,5);
max_value=(ceil(max(max(pre_all_nodes_mac(:,1)),max(pre_all_nodes_hw(:,1)))/10) + 1) *10;
scatter(pre_all_nodes_mac(:,1),pre_all_nodes_hw(:,1));

grid on;
xlabel('mac-busy');
ylabel('hw-busy');
title('pre all nodes measurement');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);


%all nodes during measurement

subplot(Y_PLOT_SIZE,X_PLOT_SIZE,6);
max_value=(ceil(max(max(dur_rx_nodes_mac(:,2)),max(dur_rx_nodes_hw(:,2)))/10) + 1) *10;
scatter(dur_rx_nodes_hw(:,2),dur_rx_nodes_hw(:,1));

grid on;
xlabel('hw-rx');
ylabel('hw-busy');
title('hw-rx vs. hw-busy');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,7);
scatter(dur_rx_nodes_mac_hw_diff(:,1),dur_rx_nodes_noise(:,1));

grid on;
xlabel('mac-hw-diff (busy)');
ylabel('noise');
title('noise vs. hw');

hold on;


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,8);
scatter(dur_rx_nodes_mac_hw_diff(:,1),dur_rx_nodes_crc(:,1));

grid on;
xlabel('mac-hw-diff (busy)');
ylabel('crc');
title('crc vs. hw');

hold on;


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,9);
scatter(dur_rx_nodes_mac_hw_diff(:,1),dur_rx_nodes_phy(:,1));

grid on;
xlabel('mac-hw-diff (busy)');
ylabel('phy');
title('phy vs. hw');

hold on;


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,10);
max_value=(ceil(max(max(dur_rx_nodes_mac(:,1)),max(dur_rx_nodes_hw(:,1)))/10) + 1) *10;
scatter(dur_rx_nodes_mac(:,1),dur_rx_nodes_hw(:,1));

grid on;
xlabel('mac-busy');
ylabel('hw-busy');
title('rx nodes during measurement');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,11);
max_value=(ceil(max(max(dur_rx_nodes_mac(:,2)),max(dur_rx_nodes_hw(:,2)))/10) + 1) *10;
scatter(dur_rx_nodes_mac(:,2),dur_rx_nodes_hw(:,2));

grid on;
xlabel('mac-rx');
ylabel('hw-rx');
title('rx nodes during measurement');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,12);
max_value=(ceil(max(max(dur_rx_nodes_mac(:,4)),max(dur_rx_nodes_hw(:,1)))/10) + 1) *10;
scatter(dur_rx_nodes_mac(:,4),dur_rx_nodes_hw(:,1));

grid on;
xlabel('mac-rx_no_err');
ylabel('hw-busy');
title('rx nodes during measurement');

hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);


subplot(Y_PLOT_SIZE,X_PLOT_SIZE,13);
scatter(dur_rx_nodes_mac(:,1),dur_rx_nodes_sysload(:,1));

grid on;
xlabel('mac-busy');
ylabel('load');
title('mac-busy vs. load');

hold on;

end
