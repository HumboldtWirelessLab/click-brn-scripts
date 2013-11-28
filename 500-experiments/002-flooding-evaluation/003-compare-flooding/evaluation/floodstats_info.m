%function floodstats_info(simple_filename, e2e_filename, prop_filename)

%ilename = 'result_flooding_info.dat';
simple_filename = '20131127/result_flooding_info.dat.simple';
e2e_filename = '20131127/result_flooding_info.dat.e2e';
prop_filename = '20131127/result_flooding_info.dat.unicast';

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
E2E=44;

%load('flooding_pre_data.dat','-mat');

params=[UNICASTSTRATEGY UNICAST_PRESELECTION_STRATEGY UNICAST_REJECTONEMPTYCS UNICAST_UCASTPEERMETRIC FLOODING_NET_RETRIES ALGORITHMID EXTRAINFO  MACRETRIES NBMETRIC PIGGYBACK FRESP USEASS MAXDELAY TXABORT FIXCS E2E ];

% UNICASTSTRATEGY
% UNICAST_PRESELECTION_STRATEGY
% UNICAST_REJECTONEMPTYCS
% UNICAST_UCASTPEERMETRIC
% FLOODING_NET_RETRIES
% ALGORITHMID (simple/mpr/prob)
% EXTRAINFO (Algo, e.g. probab)
% MACRETRIES
% NBMETRIC


%NAIVE
if (~exist('flood_sent'))

  data=load(simple_filename);

  % strategy
  net_retries_naive = unique(data(data(:,UNICASTSTRATEGY) == 0 & data(:,E2E) == 0,FLOODING_NET_RETRIES));

  net_retries_naive = [ 0 1 2 3 4 ]';

  src_nodes = unique(data(:,SRCNODE));
  params_value=unique(data(:,params),'rows');

  %%
  % NAIVE FLOODING
  flood_delays = [];
  flood_reach = [];
  flood_sent = [];
  flood_xlb = [];

  param_id = 1;

  for nn=1:size(net_retries_naive,1)
    flood_retries = net_retries_naive(nn);
    method = data(data(:,UNICASTSTRATEGY) == 0 & data(:,FLOODING_NET_RETRIES) == flood_retries & data(:,E2E) == 0,:);
    seeds = unique(method(:,SEED));
    flIds = unique(method(:,FLOODINGID));

    all_delays = [];
    reach = [];
    all_sent = [];

    flood_xlb = [ flood_xlb; [ 0 net_retries_naive(nn) 0 ]];

    for ff=1:size(flIds,1)
      for ss=1:size(seeds,1)
        for sn=1:size(src_nodes,1)
            fl_1 = method(method(:,FLOODINGID) == flIds(ff) & method(:,SEED) == seeds(ss) & (method(:,SRCNODE) == src_nodes(sn)),:);

            %size(fl_1)
            %fl_1(:,[RXNODE TXNODE SRCNODE ])
            src_node = unique(fl_1(:,SRCNODE));
            assert(size(src_node,1) == 1 & size(src_node,2) == 1);

            start_time = min(fl_1(fl_1(:,RXNODE) == src_node,TIME));

            rx_times = fl_1(fl_1(:,RXNODE) ~= src_node, [RXNODE TIME]);
            %size(rx_times)
            rx_nodes = unique(rx_times(:,1));
            reach = [reach; size(rx_nodes,1)];

            delays = rx_times(:,2) - start_time;
            all_delays = [all_delays; delays];

            fl_1_sent_src = unique(fl_1(fl_1(:,SRCNODE) == fl_1(:,RXNODE),NOSENT));
            fl_1_sent_fwd = fl_1(fl_1(:,SRCNODE) == fl_1(:,TXNODE),NOSENT);

            %size(fl_1_sent_src)
            %size(fl_1_sent_fwd)

            all_sent = [all_sent; (sum(fl_1_sent_src)+sum(fl_1_sent_fwd))];
        end
      end
    end

    size(all_sent)

    reach = reach + 1; % include src
    reach = reach / size(unique(method(:,RXNODE)),1);
    all_delays = all_delays * 1e3;

    flood_delays = [flood_delays; [all_delays zeros(size(all_delays,1),1) + param_id]];
    flood_reach = [flood_reach; [reach zeros(size(reach,1),1) + param_id]];
    flood_sent = [flood_sent; [all_sent zeros(size(all_sent,1),1) + param_id]];
    param_id = param_id + 1;
  end

  flood_param_id = param_id;
end


%clear flood_e2e_sent;
%%
% E2E FLOODING
if (~exist('flood_e2e_sent'))

  param_id = flood_param_id;

  data=load(e2e_filename);

  e2e_retries_e2e = unique(data(data(:,UNICASTSTRATEGY) == 0 & data(:,E2E) ~= 0, E2E));
  e2e_retries_e2e = [ 1 2 3 4 ]';

  src_nodes = unique(data(:,SRCNODE));

  flood_e2e_delays = [];
  flood_e2e_reach = [];
  flood_e2e_sent = [];
  e2e_xlb = [];

  for nn=1:size(e2e_retries_e2e,1)
    flood_retries = e2e_retries_e2e(nn);
    method = data(data(:,UNICASTSTRATEGY) == 0 & data(:,E2E) == flood_retries,:);
    seeds = unique(method(:,SEED));
    flIds = unique(method(:,FLOODINGID));

    all_delays = [];
    reach = [];
    all_sent = [];

    e2e_xlb = [ e2e_xlb; [ 0 0 e2e_retries_e2e(nn) ]];

    for ff=1:(flood_retries+1):size(flIds,1)
      all_ids = [ flIds(ff):flIds(ff+flood_retries) ];
      for ss=1:size(seeds,1)
        for sn=1:size(src_nodes,1)
            fl_1 = method( ismember(method(:,FLOODINGID),all_ids) & method(:,SEED) == seeds(ss) & (method(:,SRCNODE) == src_nodes(sn)),:);

            %size(fl_1)
            %fl_1(:,[RXNODE TXNODE SRCNODE ])
            src_node = unique(fl_1(:,SRCNODE));
            assert(size(src_node,1) == 1 & size(src_node,2) == 1);

            start_time = min(fl_1(fl_1(:,RXNODE) == src_node,TIME));

            rx_times = fl_1(fl_1(:,RXNODE) ~= src_node, [RXNODE TIME]);
            %size(rx_times)
            rx_nodes = unique(rx_times(:,1));
            reach = [reach; size(rx_nodes,1)];

            min_rx_times = [];
            for r=1:size(rx_nodes)
              min_rx_times = [ min_rx_times; min(rx_times(rx_times(:,1) == rx_nodes(r),2)) ];
            end

            delays = min_rx_times - start_time;
            all_delays = [all_delays; delays];

            fl_1_sent_src = unique(fl_1(fl_1(:,SRCNODE) == fl_1(:,RXNODE),NOSENT));
            fl_1_sent_fwd = fl_1(fl_1(:,SRCNODE) == fl_1(:,TXNODE),NOSENT);

            all_sent = [all_sent; (sum(fl_1_sent_src)+sum(fl_1_sent_fwd))];
        end
      end
    end

    size(all_sent)

    reach = reach + 1; % include src
    reach = reach / size(unique(method(:,RXNODE)),1);
    all_delays = all_delays * 1e3;

    flood_e2e_delays = [flood_e2e_delays; [all_delays zeros(size(all_delays,1),1) + param_id]];
    flood_e2e_reach = [flood_e2e_reach; [reach zeros(size(reach,1),1) + param_id]];
    flood_e2e_sent = [flood_e2e_sent; [all_sent zeros(size(all_sent,1),1) + param_id]];
    param_id = param_id + 1;
  end

  e2e_param_id = param_id;
end

%%
% PROPOSED METHOD
if (~exist('prop_sent'))

  param_id = e2e_param_id;

  data=load(prop_filename);

  net_retries_prop = unique(data(data(:,UNICASTSTRATEGY) == 4,FLOODING_NET_RETRIES));

  %filter
  net_retries_prop = [ 1 2 3 ]';

  prop_delays = [];
  prop_reach = [];
  prop_sent = [];

  prop_xlb = [];

  mac_retries = unique(data(:,MACRETRIES));

  for mm=1:size(mac_retries,1)
    mac_retry = mac_retries(mm);
    for nn=1:size(net_retries_prop,1)
        net_retry = net_retries_prop(nn);
        method = data(data(:,UNICASTSTRATEGY) == 4 & data(:,FLOODING_NET_RETRIES) == net_retry & data(:,MACRETRIES) == mac_retry,:);
        seeds = unique(method(:,SEED));
        flIds = unique(method(:,FLOODINGID));

        all_delays = [];
        reach = [];
        all_sent = [];

        prop_xlb = [ prop_xlb; [ mac_retries(mm) net_retries_prop(nn) 0 ]];

        for ff=1:size(flIds,1)
            for ss=1:size(seeds,1)
               for sn=1:size(src_nodes,1)
                fl_1 = method(method(:,FLOODINGID) == flIds(ff) & method(:,SEED) == seeds(ss) & (method(:,SRCNODE) == src_nodes(sn)),:);

                src_node = unique(fl_1(:,SRCNODE));
                assert(size(src_node,1) == 1 & size(src_node,2) == 1);

                start_time = min(fl_1(fl_1(:,RXNODE) == src_node,TIME));

                rx_times = fl_1(fl_1(:,RXNODE) ~= src_node, [RXNODE TIME]);
                rx_nodes = unique(rx_times(:,1));

                reach = [reach; size(rx_nodes,1)];

                delays = rx_times(:,2) - start_time;

                all_delays = [all_delays; delays];

                fl_1_sent_src = unique(fl_1(fl_1(:,SRCNODE) == fl_1(:,RXNODE),NOSENT));
                fl_1_sent_fwd = fl_1(fl_1(:,SRCNODE) == fl_1(:,TXNODE),NOSENT);

                %size(fl_1_sent_src)
                %size(fl_1_sent_fwd)

                all_sent = [all_sent; (sum(fl_1_sent_src)+sum(fl_1_sent_fwd))];
             end
          end
        end

        reach = reach + 1; % include src
        reach = reach / size(unique(method(:,RXNODE)),1);
        all_delays = all_delays * 1e3;

        prop_delays = [prop_delays; [all_delays zeros(size(all_delays,1),1) + param_id]];
        prop_reach = [prop_reach; [reach zeros(size(reach,1),1) + param_id]];
        prop_sent = [prop_sent; [all_sent zeros(size(all_sent,1),1) + param_id]];
        param_id = param_id + 1;
    end
  end
end

clear data;

save('flooding_pre_data.dat','flood_xlb', 'e2e_xlb', 'prop_xlb', 'flood_delays', 'flood_e2e_delays', 'prop_delays', 'flood_reach', 'flood_e2e_reach', 'prop_reach', 'flood_sent', 'flood_e2e_sent','prop_sent');

%%
% plot
h1 = figure(1);
xlb=[ flood_xlb; e2e_xlb; prop_xlb];
xlbs = cell(size(xlb,1),1);
for ii=1:size(xlb,1)
    xlbs{ii} = [int2str(xlb(ii,1)), '/', int2str(xlb(ii,2)), '/',int2str(xlb(ii,3)) ];
end

delays = [flood_delays; flood_e2e_delays; prop_delays];
reach = [flood_reach; flood_e2e_reach; prop_reach];
sent = [flood_sent; flood_e2e_sent;prop_sent];


%subplot(1,3,1);
boxplot(delays(:,1), delays(:,2), 'labels', xlbs);
title('Delay in [ms]');
xlabel('MAC/NET/E2E Retries');
grid on;
saveas(h1, 'delay.eps' ,'eps');

%subplot(1,3,2);
h2=figure(2);
boxplot(reach(:,1), reach(:,2), 'labels', xlbs);
title('Reachbility in [%]');
xlabel('MAC/NET/E2E Retries');
grid on;
saveas(h2, 'reach.eps' ,'eps');

%subplot(1,3,3);
h3=figure(3);
boxplot(sent(:,1), sent(:,2), 'labels', xlbs);
title('No. MAC TX');
xlabel('MAC/NET/E2E Retries');
grid on;
saveas(h3, 'sent.eps' ,'eps');
