function snr_sdr()

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

    snr = zeros(size(rates,1),size(power,1));  
    pdr = zeros(size(rates,1),size(power,1));  

    for p = 1:size(power,1)
  
      wanted_power=wanted_channel(wanted_channel(:,POWER) == power(p),:);
          
      if ( ~isempty(wanted_power) )
    
        for r = 1:size(rates,1)
        
          wanted_rate=wanted_power(wanted_power(:,RATE) == rates(r),:);
     
          if ( ~isempty(wanted_rate) )
            snr(r,p) = mean(wanted_rate(:,RSSI));
            pdr(r,p) = size(wanted_rate,1) / 1000;
          else
            snr(r,p) = 0;  
            pdr(r,p) = 0;  
          end
        end	  
      end
    end
   
    snr 
    pdr
    for r = 1:size(rates,1)
      figure(r)
      scatter(snr(r,:),pdr(r,:))
      title(strcat('Rate: ', num2str(rates(r)),' MBit/s'));
      xlim([0 45])
      ylim([0 1])
      grid on;
    end
    
    
  end
end

scrsz = [ 0 0 640 480];

%print('-dpsc','txpower_rxpower.ps');

end
