function power_curve()

res = load('result.mat','-ASCII');

%POSITION CHANNEL POWER TIME RATE HT RATEINDEX HT40 SGI CTL_RSSI0 CTL_RSSI1 EXT_RSSI0 EXT_RSSI1 RSSI NOISE

a=res(:,[2 3 5 10 11 12 13 14]);

CHANNEL=1;
POWER=2;
RATE=3;
RSSI=8;

channel = unique(a(:,CHANNEL));
power = unique(a(:,POWER));
rates = sort(unique(a(:,RATE)))
%rates(rates(:) == 6) = [];

mean_values = zeros(size(channel,1), size(rates,1), size(power,1));

for c = 1:size(channel,1)
  wanted_channel=a(a(:,CHANNEL) == channel(c),:);
  
  if ( ~isempty(wanted_channel) )
    
    for p = 1:size(power,1)
  
      wanted_power=wanted_channel(wanted_channel(:,POWER) == power(p),:);
    
      if ( ~isempty(wanted_power) )
    
        for r = 1:size(rates,1)
        
          wanted_rate=wanted_power(wanted_power(:,RATE) == rates(r),:);
     
          if ( ~isempty(wanted_rate) )
            mean_values(c,r,p) = mean(wanted_rate(:,RSSI));
          end
        end	  
      end
    end
  end
end

scrsz = [ 0 0 640 480];

%mean_values
%mean_values(1,1)
%size(k(1,:))
%size([1:size(power,1)])
%col=[ 1 4 3 2 5 ]
col=[ 'k', 'b', 'r', 'g', 'm', 'k' ];
rates

size(rates)
for c = 1:size(channel,1)
   channel(c)
   mean_values(c,2,27)
   for r = 1:size(rates,1)
     k=mean_values(c,r,:);
     plot([1:size(power,1)],k(1,:),col(r));
     hold on;
   end
end
grid on;
xlabel('txpower (dbm)');
ylabel('snr (db)');
title('TXPower vs. RXSNR (5 GHz and 2.4Ghz)');
legend('1MBit/s', '6MBit/s', '6.5MBit/s (HT20, 1 Stream)', '13MBit/s (HT20, 2 Streams)', '13.5MBit/s (HT40, 1 Stream)', '27MBit/s (HT40, 2 Streams)', 'location', 'northwest');

%print('-landscape','-dpsc','txpower_rxpower.ps');
print('-dpsc','txpower_rxpower.ps');

end
