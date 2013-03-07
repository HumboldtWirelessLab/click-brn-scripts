%close all;
clear;

%dir = 'weak_signal/weak_power.30.rate.12/evaluation/';

% params
txpower = 28;%26;%26;
bitrate = 18;%9;%6;

%dir = ['weak_signal/weak_power.', int2str(txpower), '.rate.', int2str(bitrate*2), '/evaluation/'];
%dir = ['aci/aci_base/evaluation/'];
%dir = ['aci/aci_acitwolinks/evaluation/']; % TOP!!!
%dir = ['aci/aci_power.36/evaluation/'];
%dir = ['aci/aci_noacilink/evaluation/'];
    
%dir = ['../hiddennode_power_001/hiddennode_power.20.distpower.35/evaluation/'];
%dir = ['../inrange_002/inrange_power.36.rate.12/evaluation/'];
%dir = ['../inrange_003_5Ghz_6MBit/inrange_power.12.rate.12/evaluation/'];
%dir = ['../inrange_004_2.4Ghz_6MBit/inrange_power.12.rate.12/evaluation/'];
%dir = ['../inrange_005_2.4Ghz_1MBit/inrange_power.12.rate.2/evaluation/'];
%dir = ['../inrange_channel_14.rate.2/inrange_power.2.rate.2/evaluation/'];
dir = ['../inrange_channel_13.rate.12/inrange_power.36.rate.12/evaluation/'];
%dir = ['../inrange_channel_46.rate.12/inrange_power.26.rate.12/evaluation/'];

% RX node
%rx_node_names = {'foobar103', 'commander105'};
rx_node_names = {'commander105', 'foobar103'};
%rx_node_names = {'commander105', 'seismo158', 'foobar103'};
%rx_node_names = {'commander105', 'seismo176'};
%rx_node_names = {'foobar103', 'seismo176', 'commander105'};
%rx_node_names = {'commander105', 'seismo176', 'foobar103','seismo158'};
%rx_node_names = {'commander105', 'seismo162', 'foobar103','seismo158'};
%rx_node_names = {'foobar103'};

ydumps = {};
sync_v = {};

%
% Synchronization
%
for kk=1:size(rx_node_names,2)
    
    rx_node_name = rx_node_names{kk};
    
    % packet trace
    fnamedump = ['regmon_dump_info_', rx_node_name];

    %Spalte: Inhalt
    %1: rx(0) o. tx(1)
    %2: Status: 0=OK 1=CRC 2=PHY
    %3: PhyerrInfo
    %4: RSSI
    %5: L�nge, MAC-Frame in Bytes
    %6: Rate (*2)
    %7: ktime
    %8: Kanal
    %9: DriverFlags
    %10: Pkt Flags: 0. Bit:shortpreamble1 1.Bit-hrtime
    %     3->ShortPreamble+HRtime
    %11: SEQ

    ydumps{kk} = load([dir, fnamedump]);
    
    % sync vector
    sync_v{kk} = ydumps{kk}(ydumps{kk}(:,2) == 0 & ydumps{kk}(:,5) == 69,[7 11]);
    sync_v{kk} = sync_v{kk}(2:end,:);
end


%common_sync_packets = intersect(intersect(sync_v{1}(:,2), sync_v{2}(:,2)), sync_v{3}(:,2));

common_sync_packets = sync_v{1}(:,2);
for kk=2:size(rx_node_names,2)
    common_sync_packets = intersect(common_sync_packets, sync_v{kk}(:,2));
end

tmp = zeros(size(common_sync_packets,1),1);
for tt=1:size(common_sync_packets,1)
    [a b] = find(sync_v{1}(:,2) == common_sync_packets(tt));
    tmp(a) = common_sync_packets(tt);
end
common_sync_packets = tmp;

time_deltas = {};

for pp=2:size(rx_node_names,2)
    time_deltas{pp} = zeros(size(common_sync_packets,1), 3);
    for kk=1:size(common_sync_packets,1)
        sync_p = common_sync_packets(kk);
        if (sync_p ~= 0)
            time_first = sync_v{1}(sync_v{1}(:,2) == sync_p,1);
            time_second = sync_v{pp}(sync_v{pp}(:,2) == sync_p,1);
            time_deltas{pp}(kk,:) = [time_first time_second time_first - time_second];
        end
    end
end

for pp=2:size(rx_node_names,2)
    % init time offset
    time_offset_init = time_deltas{pp}(1,3);

    % drift per nanosecond
    time_drift_per_ns = (time_deltas{pp}(end,3) - time_deltas{pp}(1,3)) / (time_deltas{pp}(end,1) - time_deltas{pp}(1,1));

    % time correction

    add_time_drift = (ydumps{pp}(:,7) - time_deltas{pp}(1,2)) * time_drift_per_ns;
    ydumps{pp}(:,7) = ydumps{pp}(:,7) + time_offset_init + add_time_drift;
end

% remove sync packets from trace
%for kk=1:size(rx_node_names,2)
%    ydumps{kk}(ydumps{kk}(:,2) == 0 & ydumps{kk}(:,5) == 69,:) = [];
%end

% Correct RX time of packets by subtracting packet length
for kk=1:size(rx_node_names,2)
    
    % consider only OK
    %ydump(ydump(:,2) ~= 0,:) = [];

    % filter strange packets; wrong status
    ydumps{kk}(ydumps{kk}(:,2) > 2,:) = [];
    ydumps{kk}(ydumps{kk}(:,2) < 0,:) = [];
    % wrong rate
    ydumps{kk}(ydumps{kk}(:,6) == 0,:) = [];
    % RX
    assert(unique(ydumps{kk}(:,1)) == 0);
    % RSSI bug
    ydumps{kk}(ydumps{kk}(:,4) > 100,4) = 0;

    % correct rx time in dump file
    air_time = tx_time(ydumps{kk}(:,6)/2, ydumps{kk}(:,10) == 3, ydumps{kk}(:,5)) * 1000; % nsec
    ydumps{kk}(:,7) = ydumps{kk}(:,7) - air_time;
    airTimeCol = size(ydumps{kk},2)+1;
    ydumps{kk}(:,airTimeCol) = air_time;
end

%
% load HW registers of foobar only
rx_node_name = rx_node_names{1}; % foobar

fnamereg = ['regmon_data_', rx_node_name, '.dec'];

%regmon_data_50..
%1: jiffies
%2: ktime low32 (ignorieren)
%3: ktime high32 (ignor)
%4: cycle_cnt
%5: busy_cyc
%6: rx_cyc
%7: tx_cyc
%8: ktime

yreg = loadhwdata([dir, fnamereg]);

% set start to 0
time_diff = min(yreg(:,8));
yreg(:,8) = yreg(:,8) - time_diff;

for kk=1:size(rx_node_names,2)
    ydumps{kk}(:,7) = ydumps{kk}(:,7) - time_diff;
end


%
% analyze subset
%

xx = 1;
yy = size(yreg,1);
if (1)
    % start in ringbuffer
    xx = 20001;
    % end in ringbuffer
    yy = 25000;
end

% points in reg file
yregpart = yreg(xx:yy,:);

busy = yregpart(:,5) ./ yregpart(:,4);
rx = yregpart(:,6) ./ yregpart(:,4);
tx = yregpart(:,7) ./ yregpart(:,4);
timereg = yregpart(:,8);

ydumppart = {};

for kk=1:size(rx_node_names,2)
    % subset in dump
    ydumppart{kk} = ydumps{kk}(ydumps{kk}(:,7) >= min(timereg) & ydumps{kk}(:,7) <= max(timereg),:);
end

%
% TEST
%
if (1)
    %scrsz = get(0,'ScreenSize');
    %figure1 = figure('Position',[100 100 scrsz(3)/1.5 scrsz(4)/1.5]);
    figure1 = figure();
    % plot HW registers
    %plot(timereg, busy, '+r', timereg, rx, '+b', timereg, tx, '+g');
    plot(timereg, busy, '+r', timereg, rx, '+b');
   
    % Create textbox
    annotation(figure1,'textbox',...
        [0.1 0.5 + kk*0.03 0.05 0.05],...
        'String',{rx_node_name},...
        'FontWeight','bold',...
        'FontSize',12,...
        'FontName','Calibri',...
        'LineStyle','none');
    
    
    % plot RX packet trace
    for kk=1:size(rx_node_names,2)
        dumprg = [ydumppart{kk}(:,7) (ydumppart{kk}(:,7) + ydumppart{kk}(:,airTimeCol)) ydumppart{kk}(:,2) ydumppart{kk}(:,11)];
        for jj=1:size(dumprg,1)
            hold on;
            % packet start + end
            plot(dumprg(jj,1), 1.03 + kk*0.05, ['>', mystyle(dumprg(jj,3))], dumprg(jj,2), 1.03 + kk*0.05, ['<', mystyle(dumprg(jj,3))]);
            hold on;
            % SEQ
            text(dumprg(jj,1), 1.05 + kk*0.05, int2str(dumprg(jj,4)));
            if (kk==2)
                hold on;
                line([dumprg(jj,1) dumprg(jj, 1)], [0 1.03 + kk*0.05], 'Color', 'k', 'LineStyle', ':');
                hold on;
                line([dumprg(jj,2) dumprg(jj, 2)], [0 1.03 + kk*0.05], 'Color', 'k', 'LineStyle', ':');
            end
        end
        % Create textbox
        annotation(figure1,'textbox',...
            [0.1 0.75 + kk*0.03 0.05 0.05],...
            'String',{rx_node_names{kk}},...
            'FontWeight','bold',...
            'FontSize',12,...
            'FontName','Calibri',...
            'LineStyle','none');
    end

    %legend('Busy/CC', 'RX/CC', 'TX/CC', 'RX-PacketTrace', 'TX-PacketTrace', 'Location', 'SouthEast');
    legend('Busy/CC', 'RX/CC', 'TX/CC', 'RX-PacketTrace', 'Location', 'SouthEast');
    ylim([0 1.25]);
    
    %title_str = ['P=', int2str(txpower), ',R=', num2str(bitrate)];
    %title(title_str);
    title(dir);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detector
%
if (0)
    % Samples for range: xx = 5000 and yy = 10000;
    not_rx_packets = [589 590 592 593 594 595 596 597 598 599 600 601 602 603 604 605 606 607 608 609];

    trunc = 3;
    busy_buckets = {};
    rx_buckets = {};
    for ii=1:size(not_rx_packets,2)
        p_id = not_rx_packets(ii);
        kk=2;
        dumprg = [ydumppart{kk}(:,7) (ydumppart{kk}(:,7) + ydumppart{kk}(:,airTimeCol)) ydumppart{kk}(:,2) ydumppart{kk}(:,11)];
        range_bucket = find((timereg > dumprg(dumprg(:,4) == p_id, 1) & timereg < dumprg(dumprg(:,4) == p_id, 2)));

        busy_bucket = busy(range_bucket);
        busy_bucket = busy_bucket(trunc:end-trunc);
        busy_buckets{ii} = busy_bucket;

        rx_bucket = rx(range_bucket);
        rx_bucket = rx_bucket(trunc:end-trunc);
        rx_buckets{ii} = rx_bucket;
    end

    busy_all = [];
    rx_all = [];
    for ii=1:size(not_rx_packets,2)
       busy_all = [busy_all mean(busy_buckets{ii})];
       rx_all = [rx_all mean(rx_buckets{ii})];
    end

    if (0)
       figure; 
       distributionPlot(busy_buckets);
       title('Busy Reg of ACI corrupted');
       figure; 
       boxplot([rx_all; busy_all]');
       title('RX/Busy Reg of ACI corrupted');
    end

    % Samples for range: xx = 5000 and yy = 10000;
    correct_rx_packets = [573:576 578:581 583:586 590:592];

    trunc = 3;
    busy_buckets = {};
    rx_buckets = {};
    for ii=1:size(correct_rx_packets,2)
        p_id = correct_rx_packets(ii);
        kk=1;
        dumprg = [ydumppart{kk}(:,7) (ydumppart{kk}(:,7) + ydumppart{kk}(:,airTimeCol)) ydumppart{kk}(:,2) ydumppart{kk}(:,11)];
        range_bucket = find((timereg > dumprg(dumprg(:,4) == p_id, 1) & timereg < dumprg(dumprg(:,4) == p_id, 2)));

        busy_bucket = busy(range_bucket);
        busy_bucket = busy_bucket(trunc:end-trunc);
        busy_buckets{ii} = busy_bucket;

        rx_bucket = rx(range_bucket);
        rx_bucket = rx_bucket(trunc:end-trunc);
        rx_buckets{ii} = rx_bucket;
    end

    busy_all = [];
    rx_all = [];
    for ii=1:size(correct_rx_packets,2)
       busy_all = [busy_all mean(busy_buckets{ii})];
       rx_all = [rx_all mean(rx_buckets{ii})];
    end

    if (0)
       figure; 
       distributionPlot(busy_buckets);
       title('Busy Reg of OK');
       figure; 
       boxplot([rx_all; busy_all]');
       title('RX/Busy Reg of OK');
    end
end
