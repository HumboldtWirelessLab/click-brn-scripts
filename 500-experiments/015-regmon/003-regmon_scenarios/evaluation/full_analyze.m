function full_analyze(pktfile, regmonfile)

%dir = '27_strong_hn/';
%dir = '29_weak/';
%dir = '30_inrange/';

% start in ringbuffer
xx = 10000; %big
xx = 7000;
xx = 001;
% end in ringbuffer
yy = 11500; %big
yy = 8000; 
yy = 99000; 

%
% Do not touch
%
fnamedump = 'regmon_dump_info';

%Spalte: Inhalt
%1: rx(0) o. tx(1)
%2: Status: 0 OK 1 CRC 2 PHY
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

ydump = load(pktfile);

fnamereg = 'regmon_data.dec';

%regmon_data_50..
%1: jiffies
%2: ktime low32 (ignorieren)
%3: ktime high32 (ignor)
%4: cycle_cnt
%5: busy_cyc
%6: rx_cyc
%7: tx_cyc
%8: ktime

yreg = loadhwdata(regmonfile);

% some checks
if (isempty(ydump))
    ydump = zeros(2,11);
end
    
% consider only OK
%ydump(ydump(:,2) ~= 0,:) = [];

% filter strange packets; wrong status
ydump(ydump(:,2) > 2,:) = [];
ydump(ydump(:,2) < 0,:) = [];

% wrong rate
ydump(ydump(:,6) == 0,:) = [];


% RX
%assert(unique(ydump(:,1)) == 0);
% RSSI bug
ydump(ydump(:,4) > 100,4) = 0;

packet_len = 1496;

% correct rx time in dump file
air_time = tx_time(ydump(:,6)/2, ydump(:,10) == 3, ydump(:,5)) * 1000; % nsec
ydump(:,7) = ydump(:,7) - air_time;
airTimeCol = size(ydump,2)+1;
ydump(:,airTimeCol) = air_time;


% Join: 7: ktime und 8: ktime

% analyze subset

% points in reg file
yregpart = yreg(xx:yy,:);

busy = yregpart(:,5) ./ yregpart(:,4);
rx = yregpart(:,6) ./ yregpart(:,4);
tx = yregpart(:,7) ./ yregpart(:,4);

%busy = yregpart(:,5) * 25 / 10^3;
%rx = yregpart(:,6) * 25 / 10^3;
%tx = yregpart(:,7) * 25 / 10^3;


timereg = yregpart(:,8);

% subset in dump
ydumppart = ydump(ydump(:,7) >= min(timereg) & ydump(:,7) <= max(timereg),:);

%
% TEST
%
figure; 

plot(timereg, busy, '+r', timereg, rx, '+b', timereg, tx, '+g'); %timereg
dumprg = [ydumppart(:,7) ydumppart(:,7) + ydumppart(:,airTimeCol) ydumppart(:,2) ydumppart(:,11)];
for jj=1:size(dumprg,1)
    %plot(dumprg(jj,1):dumprg(jj,2), ones(size(dumprg(jj,1):dumprg(jj,2),2),1), '-k');
    hold on;
    plot(dumprg(jj,1), 1.05, ['>', mystyle(dumprg(jj,3))], dumprg(jj,2), 1.05, ['<', mystyle(dumprg(jj,3))]);
    %hold on;
    %text(dumprg(jj,1), 1.07, int2str(dumprg(jj,4)));
end

legend('Busy/CC', 'RX/CC', 'TX/CC', 'RX-PacketTrace', 'Location', 'SouthEast');
ylim([0 1.1]);

%print('regmon.png','-dpng');
%print('regmon.eps','-deps');

end