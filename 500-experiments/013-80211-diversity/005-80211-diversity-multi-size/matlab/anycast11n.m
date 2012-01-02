RELOAD = 1;
GUI = 0;
MIN_PDR = 0.05;

TOTAL_PACKET_CNT = 10000;
packet_size = 50;%2200;
STATE = 1; %1=OK, 0=CRC
RATE = 6.5;%1;
HT = 1;%1;%0;
RATEINDEX = 0;
HT40 = 0;
SGI = 0;

title_str = ['R=', num2str(RATE), ',HT=', int2str(HT), ',RI=', int2str(RATEINDEX), ',H40=', int2str(HT40), ',SGI=', int2str(SGI)];

% META: 1=TIME SIZE SRC DST 5=STATE RATE HT RATEINDEX HT40 10=SGI RSSI NOISE SEQ CTL_RSSI0 15=CTL_RSS1 EXT_RSSI0 EXT_RSS1
% META2: TIME SIZE SRC DST STATE RATE HT RATEINDEX HT40 SGI RSSI NOISE SEQ CTL_RSSI0 CTL_RSS1 EXT_RSSI0 EXT_RSS1 PACKETID
% 1mbps 11b + 6.5mbps 11n
if (RELOAD)
    data = load('old_driver/allresult_1.txt');
    % 6mbps, 11g
    %data = load('old_driver/allresult_g.txt');
end
fdata = data(data(:,2) == packet_size, :);
fdata = fdata(fdata(:,5) == STATE, :);
fdata = fdata(fdata(:,6) == RATE, :);
fdata = fdata(fdata(:,7) == HT, :);
fdata = fdata(fdata(:,8) == RATEINDEX, :);
fdata = fdata(fdata(:,9) == HT40, :);
fdata = fdata(fdata(:,10) == SGI, :);

assert(~isempty(fdata));

src_nodes = unique(fdata(:,3));

% pdr map
no_nodes = 40;
assert(max(unique(fdata(:,4))) <= no_nodes);
pdr_map = zeros(no_nodes, no_nodes);

% packet seq map
packet_map = cell(no_nodes,no_nodes);

for s_ii=1:size(src_nodes,1)
    src = src_nodes(s_ii); 
    src_data = fdata(fdata(:,3) == src,:);

    dsts = unique(src_data(:,4));
    
    for d_ii=1:size(dsts,1)
        dst = dsts(d_ii);
        dst_data = src_data(src_data(:,4) == dst,:);
        assert(size(dst_data,1) <= TOTAL_PACKET_CNT);
        
        if (GUI)
            figure;
            subplot(3,1,1); hist([0; dst_data(:,11); 60], 60); xlim([0 60]); grid on;
            title(['MRC RSSI: ', int2str(src), '->', int2str(dst)]);
            subplot(3,1,2); hist([0; dst_data(:,14); 60], 60); xlim([0 60]); grid on;
            title(['ANT1 RSSI: ', int2str(src), '->', int2str(dst)]);
            subplot(3,1,3); hist([0; dst_data(:,15); 60], 60); xlim([0 60]); grid on;
            title(['ANT2 RSSI: ', int2str(src), '->', int2str(dst)]);
        end
        pdr_map(src, dst) = size(unique(dst_data(:,18)),1) / TOTAL_PACKET_CNT;
        packet_map{src, dst} = dst_data(:,18);
    end
end

anycast_sz2 = [];
for ii=1:size(pdr_map,1)
    if (sum(pdr_map(ii,:)) == 0)
        continue;
    end
    tmp = pdr_map(ii,:);
    for jj=1:size(tmp,2)
        if (tmp(jj) == 0)
            continue;
        end
        for kk=1:size(tmp,2)
            if (jj == kk)
                continue;
            end
            if (tmp(kk) == 0)
                continue;
            end
        
            pdr1 = pdr_map(ii, jj);
            pdr2 = pdr_map(ii, kk);
            % cmp tmp(jj) with tmp(kk)
            both = unique([packet_map{ii, jj}; packet_map{ii, kk}]);
            both_pdr = size(both,1) / TOTAL_PACKET_CNT;
            if (both_pdr < MIN_PDR)
                continue;
            end
            anycast_sz2 = [anycast_sz2; ii jj kk pdr1 pdr2 both_pdr];
        end
    end
end

figure;
pdr_map(pdr_map <= MIN_PDR) = [];
cdfplot(pdr_map);
title(['CDFPlot Link PDR (', title_str, ')']);
ylabel('Frequency');
xlabel('PDR val');
fname = ['lnk_pde_cdf_', 'r', num2str(RATE), '_ht', int2str(HT), '_ri', int2str(RATEINDEX), '_ht40', int2str(HT40), '_sgi', int2str(SGI), '.eps'];
print('-depsc', fname);

figure;
both_indep = 1 - (1-anycast_sz2(:,4)) .* (1-anycast_sz2(:,5));
scatter(both_indep, anycast_sz2(:,6));
grid on;
xlabel('Indep = 1- (1-PER(P1))*(1-PER(P2))');
ylabel('PDR(X1 \cup X2)');
title(['PDR: Indep vs. Union (', title_str, ')']);
fname = ['both_pdr_scatter_', 'r', num2str(RATE), '_ht', int2str(HT), '_ri', int2str(RATEINDEX), '_ht40', int2str(HT40), '_sgi', int2str(SGI), '.eps'];
print('-depsc', fname);
