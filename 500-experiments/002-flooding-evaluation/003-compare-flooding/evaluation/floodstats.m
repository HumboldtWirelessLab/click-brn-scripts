function floodstats(configfilename, datafilename)

config_info

plot = 1;

config_data=load(configfilename);
size(config_data)

%params_index
      
params=unique(config_data(:,params_index),'rows');

% UNICASTSTRATEGY
% UNICAST_PRESELECTION_STRATEGY
% UNICAST_REJECTONEMPTYCS
% UNICAST_UCASTPEERMETRIC
% FLOODING_NET_RETRIES
% ALGORITHMID (simple/mpr/prob)
% EXTRAINFO (Algo, e.g. probab)
% MACRETRIES
% NBMETRIC
% PIGGYBACK
% FRESP
% USEASS
% MAXDELAY
% TXABORT
% TXSCHEDULING

config_data=[ config_data';zeros(1,size(config_data,1)) ]';

all_delays=unique(config_data(:,[MAXDELAY]));

%params
%size(params)
%size(all_delays)
%unique(params(:,13))

show_all_params = 1

if show_all_params == 1
  for r = 1:size(params,2)
    p_id_num = r  
    p_id_name(r)
    unique(params(:,r))
  end
end


%get wanted params
params=params(find((params(:,1) == 0) | (params(:,1) == 7)) ,:);                       %reject option

%params=params(find((params(:,2) == 0)) ,:);                                           %preselection

params=params(find((params(:,3) ~= 0) | (params(:,1) == 0)) ,:);                       %reject option
%size(params)
params=params(find((params(:,1) == 0) | (params(:,4) == 1)) ,:);                       %peer metric                                      
%size(params)
params=params(find((params(:,1) == 0) | (params(:,5) == 2)) ,:);                       %net retries
%size(params)
params=params(find((params(:,1) == 0) | (params(:,8) == 0) | (params(:,8) == 4) | (params(:,8) == 7)) ,:);  %MAC_retries
%size(params)
params=params(find((params(:,10) == 0) | (params(:,10) == 20)) ,:);                    %piggybag
%size(params)
params=params(find((params(:,13) == 10) | (params(:,13) == 20) | (params(:,13) == 50) | (params(:,13) == 100) | (params(:,13) == 150)),:);                                             %maxdelay

params=params(find((params(:,15) == 4)),:);                                            %txscheduling


params
size(params)

%load data
data=load(datafilename);
%size(data)

%index in result matrix

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
    
    p = params(r,:);
    %p_ids = config_data(strmatch(p,config_data(:,params_index)),CONFIGID)
    p_ids = strmatch(p,config_data(:,params_index));
    
    %TODO: search for config-ids instead og using them as index
    p_data=data(p_ids,:);
    %size(p_data)

    result(r,1)=r;
    
    result(r,RESULT_REACH)=mean(p_data(:,REACH));
    reach_bp = [ reach_bp [ ones(1,size(p_data,1))*r ; p_data(:,REACH)' ;  p_data(:,NO_NODES)'; p_data(:,SOURCE_NEW)' ]];
    
    result(r,RESULT_SENT)=mean(p_data(:,SENT));
    sent_bp = [ sent_bp [ ones(1,size(p_data,1))*r ; p_data(:,SENT)' ]];
    
    result(r,RESULT_RECEIVED)=mean(p_data(:,RECEIVED));
    received_bp = [ received_bp [ ones(1,size(p_data,1))*r ; p_data(:,RECEIVED)' ]];

    result(r,RESULT_COLLISIONS)=mean(p_data(:,COLLISIONS));
    
    size(p_data);
    
    result(r,RESULT_SENT_PER_NODE)=(result(r,RESULT_SENT) / (max_no_nodes * result(r,RESULT_REACH) * max_src_pkt));

end

show_params = [1:15];
%show_params = [1 2 3 4 5 8 9 10];

%size(result,1)
%size(unique(params(:,show_params),'rows'),1)

s1 = size(result,1)/size(unique(params(:,show_params),'rows'),1);
s2 = size(unique(params(:,show_params),'rows'),1);

%s1 = 3;
%s2 = 6;
%size(result)
result

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
