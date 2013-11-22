%function floodstats_info(filename)

filename = 'result_flooding_info.dat';

NUM=1;

TXNODE=2;
RXNODE=3;
SRCNODE=4;
PACKETSIZE=5;


PACKETCOUNT=11;
FLOODINGID=12;
NOFWD=13;

NOSENT=14;   % <<----- number of sent copies (MAC)

FWD=15;
RESP=16;
FORRESP=17;
RXACKED=18;
RCVCNT=19;


FWDDONE=20;
FWDSUCC=21;
FINRESP=22;
TIME=23;     % <<------ RX time of the first pkt of the flooding

SIM=24;
UNICASTSTRATEGY=25;
PLACEMENT=26;
UNICAST_PRESELECTION_STRATEGY=27;
UNICAST_REJECTONEMPTYCS=28;
UNICAST_UCASTPEERMETRIC=29;
FLOODING_NET_RETRIES=30;


ALGORITHMID=31;
EXTRAINFO=32;
UNICASTSTRATEG=33;

COLLISIONS=34;
MACRETRIES=35;
NBMETRIC=36;
PIGGYBACK=37;
FRESP=38;
USEASS=39;
MAXDELAY=40;

SEED=41;
TXABORT=42;
FIXCS=43;

plot = 1;
s1 = 3;
s2 = 18;

if (~exist('data'))
    data=load(filename);
    %size(data)
    data=[ data';zeros(1,size(data,1)) ]';

    %PARAMETER
    %        1                           2                       3                         4                       5                6        7          8        9         10      11     12        13     14     15
    params=[UNICASTSTRATEGY UNICAST_PRESELECTION_STRATEGY UNICAST_REJECTONEMPTYCS UNICAST_UCASTPEERMETRIC FLOODING_NET_RETRIES ALGORITHMID EXTRAINFO  MACRETRIES NBMETRIC PIGGYBACK FRESP USEASS MAXDELAY TXABORT FIXCS];

    params_value=unique(data(:,params),'rows');
end

% UNICASTSTRATEGY
% UNICAST_PRESELECTION_STRATEGY
% UNICAST_REJECTONEMPTYCS
% UNICAST_UCASTPEERMETRIC
% FLOODING_NET_RETRIES
% ALGORITHMID (simple/mpr/prob)
% EXTRAINFO (Algo, e.g. probab)
% MACRETRIES
% NBMETRIC

%params_value
%size(params_value)

% strategy
net_retries = unique(data(:,FLOODING_NET_RETRIES));

%%
% NAIVE FLOODING
flood_delays = [];
flood_reach = [];
flood_sent = [];

for nn=1:size(net_retries,1)
    flood_retries = net_retries(nn);
    method = data(data(:,UNICASTSTRATEGY) == 0 & data(:,FLOODING_NET_RETRIES) == flood_retries,:);
    seeds = unique(method(:,SEED));
    flIds = unique(method(:,FLOODINGID));

    all_delays = [];
    reach = [];
    all_sent = [];
    for ff=1:size(flIds,1)
        for ss=1:size(seeds,1)
            fl_1 = method(method(:,FLOODINGID) == flIds(ff) & method(:,SEED) == seeds(ss),:);

            src_node = unique(fl_1(:,SRCNODE));
            assert(size(src_node,1) == 1 & size(src_node,2) == 1);

            start_time = min(fl_1(fl_1(:,RXNODE) == src_node,TIME));

            rx_times = fl_1(fl_1(:,RXNODE) ~= src_node, [RXNODE TIME]);
            rx_nodes = unique(rx_times(:,1));

            reach = [reach; size(rx_nodes,1)];

            delays = zeros(size(rx_nodes,1),1);
            for ii=1:size(rx_nodes,1)
                rx_node = rx_nodes(ii);
                rx_time = min(rx_times(rx_times(:,1) == rx_node,2));

                delays(ii) = rx_time - start_time;
            end
            all_delays = [all_delays; delays];
            
            all_sent = [all_sent; sum(fl_1(:,NOSENT))];
        end
    end

    reach = reach + 1; % include src
    reach = reach / size(unique(method(:,RXNODE)),1);
    all_delays = all_delays * 1e3;
    
    flood_delays = [flood_delays; [all_delays zeros(size(all_delays,1),1) + nn]];
    flood_reach = [flood_reach; [reach zeros(size(reach,1),1) + nn]];
    flood_sent = [flood_sent; [all_sent zeros(size(all_sent,1),1) + nn]];
end


%%
% PROPOSED METHOD
prop_delays = [];
prop_reach = [];
prop_sent = [];

offset = 3;

mac_retries = unique(data(:,MACRETRIES));

for mm=1:size(mac_retries,1)
    mac_retry = mac_retries(mm);
    for nn=1:size(net_retries,1)
        net_retry = net_retries(nn);
        method = data(data(:,UNICASTSTRATEGY) == 4 & data(:,FLOODING_NET_RETRIES) == net_retry & data(:,MACRETRIES) == mac_retry,:);
        seeds = unique(method(:,SEED));
        flIds = unique(method(:,FLOODINGID));

        all_delays = [];
        reach = [];
        all_sent = [];
        for ff=1:size(flIds,1)
            for ss=1:size(seeds,1)
                fl_1 = method(method(:,FLOODINGID) == flIds(ff) & method(:,SEED) == seeds(ss),:);

                src_node = unique(fl_1(:,SRCNODE));
                assert(size(src_node,1) == 1 & size(src_node,2) == 1);

                start_time = min(fl_1(fl_1(:,RXNODE) == src_node,TIME));

                rx_times = fl_1(fl_1(:,RXNODE) ~= src_node, [RXNODE TIME]);
                rx_nodes = unique(rx_times(:,1));

                reach = [reach; size(rx_nodes,1)];

                delays = zeros(size(rx_nodes,1),1);
                for ii=1:size(rx_nodes,1)
                    rx_node = rx_nodes(ii);
                    rx_time = min(rx_times(rx_times(:,1) == rx_node,2));

                    delays(ii) = rx_time - start_time;
                end
                all_delays = [all_delays; delays];

                all_sent = [all_sent; sum(fl_1(:,NOSENT))];
            end
        end

        reach = reach + 1; % include src
        reach = reach / size(unique(method(:,RXNODE)),1);
        all_delays = all_delays * 1e3;

        prop_delays = [prop_delays; [all_delays zeros(size(all_delays,1),1) + (mm-1)*size(net_retries,1) + nn + offset]];
        prop_reach = [prop_reach; [reach zeros(size(reach,1),1) + (mm-1)*size(net_retries,1) + nn + offset]];
        prop_sent = [prop_sent; [all_sent zeros(size(all_sent,1),1) + (mm-1)*size(net_retries,1) + nn + offset]];
    end
end

%%
% plot
figure(1);

xlb = [[zeros(3,1) net_retries]; reshape(repmat(mac_retries,1,3)',9,1) repmat(net_retries,3,1)];
xlbs = cell(size(xlb,1),1);
for ii=1:size(xlb,1)
    xlbs{ii} = [int2str(xlb(ii,1)), '/', int2str(xlb(ii,2))];
end


delays = [flood_delays; prop_delays];
reach = [flood_reach; prop_reach];
sent = [flood_sent; prop_sent];

subplot(1,3,1);
boxplot(delays(:,1), delays(:,2), 'labels', xlbs);
title('Delay in [ms]');
xlabel('MAC/NET Retries');
grid on;

subplot(1,3,2);
boxplot(reach(:,1), reach(:,2), 'labels', xlbs);
title('Reachbility in [%]');
xlabel('MAC/NET Retries');
grid on;

subplot(1,3,3);
boxplot(sent(:,1), sent(:,2), 'labels', xlbs);
title('No. MAC TX');
xlabel('MAC/NET Retries');
grid on;
