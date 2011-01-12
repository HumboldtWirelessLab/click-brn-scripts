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

for i = 1:size(nodes,1)
   node=nodes(i);
    
   nodes_result=result(find((result(:,2) == node) & (result(:,4) == node)),:);
   
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
   durstats_mac(i,1) = mean(nodes_result((nodes_result(1,15)+1):(nodes_result(1,15)+nodes_result(1,16)),12));
   durstats_mac(i,2) = mean(nodes_result((nodes_result(1,15)+1):(nodes_result(1,15)+nodes_result(1,16)),13));
   durstats_mac(i,3) = mean(nodes_result((nodes_result(1,15)+1):(nodes_result(1,15)+nodes_result(1,16)),14));
  
   poststats_hw(i,1) = mean(nodes_result((nodes_result(1,15)+nodes_result(1,16)+1):end,9));
   poststats_hw(i,2) = mean(nodes_result((nodes_result(1,15)+nodes_result(1,16)+1):end,10));
   poststats_hw(i,3) = mean(nodes_result((nodes_result(1,15)+nodes_result(1,16)+1):end,11));   
   poststats_mac(i,1) = mean(nodes_result((nodes_result(1,15)+nodes_result(1,16)+1):end,12));
   poststats_mac(i,2) = mean(nodes_result((nodes_result(1,15)+nodes_result(1,16)+1):end,13));
   poststats_mac(i,3) = mean(nodes_result((nodes_result(1,15)+nodes_result(1,16)+1):end,14));
   
   rates(i,1) = nodes_result(1,6)/1024;

end

prestats_diff=prestats_hw - prestats_mac;
durstats_diff=durstats_hw - durstats_mac;
poststats_diff=poststats_hw - poststats_mac;

subplot(3,2,1);
plot(prestats_hw(:,1),rates(:,1),'o');
grid on;
xlabel('HW-Busy');
ylabel('Throughtput kbits/s');


subplot(3,2,2);
plot(prestats_mac(:,1),rates(:,1),'o');
grid on;
xlabel('MAC-Busy');
ylabel('Throughtput kbits/s');


subplot(3,2,3);
max_value=(ceil(max(max(prestats_hw(:,1)),max(poststats_hw(:,1)))/10) + 1) *10;
scatter(prestats_hw(:,1),poststats_hw(:,1)); 
grid on;
xlabel('HW-Busy before measurement (%)');
ylabel('HW-Busy after measurement (%)');
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
title('before measurement');
hold on;
line([0 max_value],[0 max_value],'LineStyle','-');
xlim([0 max_value]);
ylim([0 max_value]);

end