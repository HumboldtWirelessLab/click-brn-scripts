%close all;
clear;

%dir = 'weak_signal/weak_power.30.rate.12/evaluation/';

% params
drop_first_sync_packet = 0;
show_trace_reg_plot = 1;

run_detector_aci = 1;
run_detector = 1;

txpower = 35; % power of seismo176 - constant
dist_power = 35; % power of seismo162

%ACI final strong
%txpower = 20;
%dist_power = 27;
%dir = ['../aci_power_001/aci_power.', int2str(txpower), '.distpower.', int2str(dist_power), '/evaluation/'];

%ACI weak
txpower = 18; %20 o. 6
txrate = 12;
%dir = ['../weak_power_001/weak_power.', int2str(txpower), '.rate.', int2str(txrate), '/evaluation/'];
dir = ['../weak_power.', int2str(txpower), '.rate.', int2str(txrate), '/evaluation/'];

%HiddenNode
%dir = ['../hiddennode_power.', int2str(txpower), '.distpower.', int2str(dist_power), '/evaluation/'];
%dir = ['../inrange_channel_46.rate.12/inrange_power.25.rate.12/evaluation/'];
% RX node
rx_node_names = {'foobar103', 'commander105'};
%rx_node_names = {'commander105', 'foobar103'};
%rx_node_names = {'commander105', 'seismo158', 'foobar103'};
%rx_node_names = {'commander105', 'seismo151'};
%rx_node_names = {'commander105','foobar103','seismo158'};
%rx_node_names = {'foobar103','commander105','seismo158'};
%rx_node_names = {'commander105','foobar103','seismo158'};


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
    %12: MacTime
    %13: hosttime (SetTimestsamp)
    %14: TX nodes

    ydumps{kk} = load([dir, fnamedump]);
    %ydumps{kk}(:,11)
    
    %TODO: fix seq overrun (+4096)

    % sync vector
    sync_v{kk} = ydumps{kk}(ydumps{kk}(:,2) == 0 & ydumps{kk}(:,5) == 69,[7 11]);
    sync_v{kk}
end

if (drop_first_sync_packet)
    kk=1;
    sync_v{kk} = sync_v{kk}(2:end,:);
end

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
common_sync_packets(1)
for pp=2:size(rx_node_names,2)
    pp
    time_deltas{pp} = zeros(size(common_sync_packets,1)-1, 3);
    for kk=1:size(common_sync_packets,1)-1
        sync_p = common_sync_packets(kk+1)
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

if (1)
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

size(yreg)
diff_eval_data = yreg(find(yreg(:,5) ~= yreg(:,6)),:);
size(diff_eval_data)
diff_eval_data_diff = diff_eval_data(:,5) - diff_eval_data(:,6);
figure;
hist(diff_eval_data_diff,1000);
title('Histogramm diff von rx & busy fuer rx!=busy (busy-rx)')

% set start to 0
time_diff = min(yreg(:,8));
yreg(:,8) = yreg(:,8) - time_diff;

for kk=1:size(rx_node_names,2)
    ydumps{kk}(:,7) = ydumps{kk}(:,7) - time_diff;
end



%
%  ktime diff for n samples
%
n_samples = 10;
ktime_diff_n_samples = mean(yreg(n_samples:end,8) - yreg(1:end-n_samples+1,8));


%
% analyze subset
%

xx = 1;
yy = size(yreg,1);
if (show_trace_reg_plot)
    % start in ringbuffer
    xx = 90001;
    % end in ringbuffer
    yy = 99900;
end

%ACI detector failure
% start in ringbuffer
%xx = 90000;
% end in ringbuffer
%yy = 95000;

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
% Trace & register plot
%
if (show_trace_reg_plot)
    scrsz = get(0,'ScreenSize');
    figure1 = figure('Position',[0 0 scrsz(3) scrsz(4)]);
    
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
    
    title_str = strrep(dir, '_', '\_');
    title(title_str);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (run_detector)
        thr_clock_err = 10e5;
        thr1 = 0.01;
        ph = detect_phantom(timereg, busy, rx);
        
        pkt_meantime = ydumppart{1}(:,7) + ydumppart{1}(:,airTimeCol)/2;
       
        if (1)
            
        recv_fixed_seq = zeros(size(pkt_meantime,1),1);
        for zz=1:size(pkt_meantime,1)
            tmp_seq = ydumppart{3}(ydumppart{3}(:,7) <= pkt_meantime(zz) & ydumppart{3}(:,7) + ydumppart{3}(:,airTimeCol) >= pkt_meantime(zz),11);
            if (isempty(tmp_seq))
                tmp_seq = ydumppart{1}(zz,11);
            end
            recv_fixed_seq(zz) = tmp_seq;
        end   
        
        ydumppart{1}(:,11) = recv_fixed_seq;
        
            end
        aci_result = detect_aci(ydumppart, ph, airTimeCol, ktime_diff_n_samples)
        %hn_result = detect_hn(ydumppart, ph, airTimeCol, ktime_diff_n_samples)
        
        if (show_trace_reg_plot)
            for tt=1:size(ph,1)
                hold on;
                % packet start + end
                plot(ph(tt,3), 0.9, '>k', ph(tt,4), 0.9, '<k');
                hold on;
                % artificial ID
                text(ph(tt,3), 0.925, int2str(tt));
            end

            hold on;
            % Create textbox
            annotation(figure1,'textbox',...
                [0.1 0.66 0.05 0.05],...
                'String',{'Detector'},...
                'FontWeight','bold',...
                'FontSize',12,...
                'FontName','Calibri',...
                'LineStyle','none');
        end
        
        
end
end