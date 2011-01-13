function interference_eval(matfile)

%scrsz = get(0,'ScreenSize');
scrsz = [ 1 1 800 600 ];
figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
set(gcf,'paperpositionmode','auto');
set(gca,'fontsize',16);

result=load(matfile,'-ASCII');

nodes=unique(result(:,2));

prestats_mac=zeros(size(nodes,1),3); %busy rx tx 
prestats_hw=zeros(size(nodes,1),3);
rates=zeros(size(nodes,1),1);
durstats_mac=zeros(size(nodes,1),3);
durstats_hw=zeros(size(nodes,1),3);
poststats_mac=zeros(size(nodes,1),3);
poststats_hw=zeros(size(nodes,1),3);

dur_rx_nodes_hw = zeros((size(nodes,1)-1)*size(nodes,1) ,3);
dur_rx_nodes_mac = zeros((size(nodes,1)-1)*size(nodes,1) ,3);

pre_rx_nodes_hw = zeros((size(nodes,1)-1)*size(nodes,1) ,3);
pre_rx_nodes_mac = zeros((size(nodes,1)-1)*size(nodes,1) ,3);

rx_nodes_index=1;

for i = 1:size(nodes,1)
   node=nodes(i);

   nodes_result=result(find((result(:,2) == node) & (result(:,4) == node)),:);
   rx_nodes_result=result(find((result(:,2) == node) & (result(:,4) ~= node)),:);
   
   stats=nodes_result(1,15) + nodes_result(1,16) + nodes_result(1,17);
   
   if ( stats ~= size(nodes_result,1) )
       disp('Error size')
   end
   
   prestats_hw(i,1) = mean(nodes_result(1:nodes_result(1,15),9));
   prestats_hw(i,2) = mean(nodes_result(1:nodes_result(1,15),10));
   prestats_hw(i,3) = mean(nodes_result(1:nodes_result(1,15),11));
   prestats_mac(i,1) = mean(nodes_result(1:nodes_result(1,15),12));
   prestats_mac(i,2) = mean(nodes_result(1:nodes_result(1,15),13));
   prestats_mac(i,3) = mean(nodes_result(1:nodes_result(1,15),14));

   durstats_hw(i,1) = mean(nodes_result((nodes_result(1,15)+1):(nodes_result(1,15)+nodes_result(1,16)),9));
   durstats_hw(i,2) = mean(nodes_result((nodes_result(1,15)+1):(nodes_result(1,15)+nodes_result(1,16)),10));
   durstats_hw(i,3) = mean(nodes_result((nodes_result(1,15)+1):(nodes_result(1,15)+nodes_result(1,16)),11));   
   durstats_mac(i,:) = mean(nodes_result((nodes_result(1,15)+1):(nodes_result(1,15)+nodes_result(1,16)),[12 13 14]));
  
   poststats_hw(i,:) = mean(nodes_result((nodes_result(1,15)+nodes_result(1,16)+1):end,[ 9 10 11 ]));
   poststats_mac(i,:) = mean(nodes_result((nodes_result(1,15)+nodes_result(1,16)+1):end,[ 12 13 14 ]));
   
   rates(i,1) = nodes_result(1,6)/1024;

   start_i = ((size(nodes,1)-1)*nodes_result(1,15))+1;
   end_i = ((size(nodes,1)-1)*(nodes_result(1,15)+nodes_result(1,16)));
 
%   start_i
%   end_i
%   rx_nodes_result(start_i:end_i,9)
   
   dur_rx_nodes_hw(rx_nodes_index:rx_nodes_index+size(nodes,1)-2,1) = rx_nodes_result(start_i:end_i,9);
   dur_rx_nodes_hw(rx_nodes_index:rx_nodes_index+size(nodes,1)-2,2) = rx_nodes_result(start_i:end_i,10);
   dur_rx_nodes_hw(rx_nodes_index:rx_nodes_index+size(nodes,1)-2,3) = rx_nodes_result(start_i:end_i,11);   
   dur_rx_nodes_mac(rx_nodes_index:rx_nodes_index+size(nodes,1)-2,1) = rx_nodes_result(start_i:end_i,12);
   dur_rx_nodes_mac(rx_nodes_index:rx_nodes_index+size(nodes,1)-2,2) = rx_nodes_result(start_i:end_i,13);
   dur_rx_nodes_mac(rx_nodes_index:rx_nodes_index+size(nodes,1)-2,3) = rx_nodes_result(start_i:end_i,14);
   
   pre_rx_nodes_hw_all= rx_nodes_result(1:start_i-1,[ 4 9 10 11 ]);
   pre_rx_nodes_mac_all = rx_nodes_result(1:start_i-1,[ 4 12 13 14 ]);
     
%   size(pre_rx_nodes_hw_all)   
%   size(pre_rx_nodes_mac_all)   
%
%   nodes_result(1,15)
  
   rx_nodes = unique(rx_nodes_result(:,4));
         
   for r = 1:size(rx_nodes,1)
      rx_node = rx_nodes(r);
      pre_rx_node_hw=pre_rx_nodes_hw_all(find(pre_rx_nodes_hw_all(:,1) == rx_node),:); 
      pre_rx_node_mac=pre_rx_nodes_mac_all(find(pre_rx_nodes_mac_all(:,1) == rx_node),:); 
      
%      size(pre_rx_node_hw)
%      size(pre_rx_node_mac)
      
      if ( nodes_result(1,15) ~= size(pre_rx_node_hw,1) )
        disp('Error size rx')
        pre_rx_nodes_mac
      end
      
      pre_rx_nodes_hw(rx_nodes_index+r-1,1)=mean(pre_rx_node_hw(:,2));
      pre_rx_nodes_hw(rx_nodes_index+r-1,2)=mean(pre_rx_node_hw(:,3));
      pre_rx_nodes_hw(rx_nodes_index+r-1,3)=mean(pre_rx_node_hw(:,4));
      
      pre_rx_nodes_mac(rx_nodes_index+r-1,1)=mean(pre_rx_node_mac(:,2));
      pre_rx_nodes_mac(rx_nodes_index+r-1,2)=mean(pre_rx_node_mac(:,3));
      pre_rx_nodes_mac(rx_nodes_index+r-1,3)=mean(pre_rx_node_mac(:,4));
      
   end

   rx_nodes_index = rx_nodes_index + (size(nodes,1)-1);

end

 size(pre_rx_nodes_hw)
 size(pre_rx_nodes_mac)


prestats_diff=prestats_hw - prestats_mac;
durstats_diff=durstats_hw - durstats_mac;
poststats_diff=poststats_hw - poststats_mac;

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
