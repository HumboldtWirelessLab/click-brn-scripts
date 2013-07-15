function floodstats(filename)

NUM=1;
SIM=2;
UNICASTSTRATEGY=3;
PLACEMENT=4;
UNICAST_PRESELECTION_STRATEGY=5;
UNICAST_REJECTONEMPTYCS=6;
UNICAST_UCASTPEERMETRIC=7;
FLOODING_NET_RETRIES=8;
ALGORITHMID=9;
EXTRAINFO=10;
UNICASTSTRATEG=11;
REACH=12;
SOURCE_NEW=13
RECEIVED_NEW=14;
NO_NODES=15;
FORWARD=16;
FORWARD_NEW=17;
SENT=18;
RECEIVED=19;
COLLISIONS=20;
MACRETRIES=21;
NBMETRIC=22;
PIGGYBACK=23;
FRESP=24;
USEASS=25;
MAXDELAY=26;
SEED=27;

data=load(filename);
size(data)

% UNICASTSTRATEGY
% UNICAST_PRESELECTION_STRATEGY
% UNICAST_REJECTONEMPTYCS
% UNICAST_UCASTPEERMETRIC
% FLOODING_NET_RETRIES
% ALGORITHMID (simple/mpr/prob)
% EXTRAINFO (Algo, e.g. probab)
% MACRETRIES
% NBMETRIC

data=[ data';zeros(1,size(data,1)) ]';
params=unique(data(:,[3 5 6 7 8 9 10 MACRETRIES NBMETRIC PIGGYBACK FRESP USEASS MAXDELAY]),'rows')

%get wanted params
params=params(find(params(:,5) ~= 4),:)
%size(params)

RESULT_REACH=2;
RESULT_SENT=3;
RESULT_RECEIVED=4;
RESULT_COLLISIONS=5;
RESULT_SENT_PER_NODE=6;

result=zeros(size(params,1),6);
reach_bp = [];
sent_bp = [];
received_bp = [];

max_no_nodes=max(data(:,NO_NODES));
max_src_pkt=max(data(:,SOURCE_NEW));

for r = 1:size(params,1)
    
    p=params(r,:);
       
    p_data=data(strmatch(p,data(:,[3 5 6 7 8 9 10 MACRETRIES NBMETRIC PIGGYBACK FRESP USEASS MAXDELAY])),:);
    %size(p_data)

    result(r,1)=r;
    
    result(r,RESULT_REACH)=mean(p_data(:,REACH));
    reach_bp = [ reach_bp [ ones(1,size(p_data,1))*r ; p_data(:,REACH)' ;  p_data(:,NO_NODES)'; p_data(:,SOURCE_NEW)' ]];
    
    result(r,RESULT_SENT)=mean(p_data(:,SENT));
    sent_bp = [ sent_bp [ ones(1,size(p_data,1))*r ; p_data(:,SENT)' ]];
    
    result(r,RESULT_RECEIVED)=mean(p_data(:,RECEIVED));
    received_bp = [ received_bp [ ones(1,size(p_data,1))*r ; p_data(:,RECEIVED)' ]];

    result(r,RESULT_COLLISIONS)=mean(p_data(:,COLLISIONS));
    
    size(p_data)
    
    result(r,RESULT_SENT_PER_NODE)=(result(r,RESULT_SENT) / (max_no_nodes * result(r,RESULT_REACH) * max_src_pkt));

end

plot = 1;
size(result,1)
size(unique(params(:,[1 2 3 4 5 8 9 10]),'rows'),1)

s1 = size(result,1)/size(unique(params(:,[1 2 3 4 5 8 9 10]),'rows'),1);
s2 = size(unique(params(:,[1 2 3 4 5 8 9 10]),'rows'),1);

s1 = 2;
s2 = 1;

reach=reshape(result(:,RESULT_REACH), s1, s2);
h=figure();
bar(reach','grouped');
title('Reachability (mean)');
ylabel('Reachability (%)');
xlabel('Flooding');
ylim([0.2 1.05]);
grid on;

saveas(h, 'reach_barplot.png' ,'png');
saveas(h, 'reach_barplot.fig', 'fig');


if (plot == 1)
    
collision=reshape(result(:,RESULT_COLLISIONS), s1, s2);
h=figure;
bar(collision','grouped');
title('Collision (mean)');
ylabel('Collisions');
xlabel('Flooding');
grid on;
saveas(h, 'collision_barplot.png' ,'png');      
saveas(h, 'collision_barplot.fig', 'fig');

pkt_sent=reshape(result(:,RESULT_SENT), s1, s2);
h=figure;
bar(pkt_sent','grouped');
title('Pkts sent (mean)');
ylabel('Pkts sent');
xlabel('Flooding');
grid on;
saveas(h, 'sent_barplot.png' ,'png');      
saveas(h, 'sent_barplot.fig', 'fig');

pkt_sent=reshape(result(:,RESULT_SENT_PER_NODE), s1, s2);
h=figure;
bar(pkt_sent','grouped');
title('Pkts sent per node and flooding (mean)');
ylabel('Pkts sent per node and flooding');
xlabel('Flooding');
grid on;
saveas(h, 'sent_per_node_barplot.png' ,'png');
saveas(h, 'sent_per_node_barplot.fig', 'fig');

figure;
boxplot(reach_bp(2,:),reach_bp(1,:));
title('Reachability');
ylabel('Reachability (%)');
xlabel('Flooding');
grid on;

figure;
boxplot(sent_bp(2,:),sent_bp(1,:));
title('Number of Pkts. sent');
ylabel('No. Pkts. (Sent)');
xlabel('Flooding');
grid on;

figure;
boxplot(received_bp(2,:),received_bp(1,:));
title('Pkts. received');
ylabel('No. Pkts. (Received)');
xlabel('Received');
grid on;

packets_per_reach=sent_bp(2,:)./(reach_bp(2,:) .* reach_bp(4,:) .* reach_bp(3,:)); 
figure;
boxplot(packets_per_reach,reach_bp(1,:));
title('Avg. no. Pkts. per Node for 100% Reachability');
ylabel('Pkts/Node');
xlabel('Flooding');
grid on;


%D=reachability
%fn=#of send pkt / #Knoten
%z=(D^A/((max(fn,0.25))^(1/B))

A=5;
B=2;

fn = sent_bp(2,:)./(reach_bp(3,:));
fn = max(fn, 0.25); %(fn(:)<0.25) = 0.25;
D = reach_bp(2,:);
Z = (D.^A)./(fn.^(1/B));

h=figure;
boxplot(Z,reach_bp(1,:));
title('Utility');
ylabel('Utility');
xlabel('Flooding');
grid on;
saveas(h, 'utility.png' ,'png'); 

end
end
