function eval_mcs(filename)

  PACKET_COUNT=100;
  
  raw_data = load(filename,'-ASCII');
  
  POWER = sort(unique(raw_data(:,1)));
  LINKS = sort(unique(raw_data(:,2)));
  IS_HT = sort(unique(raw_data(:,4)));
  MCSINDEX = sort(unique(raw_data(:,5)));
  HT_MODE = sort(unique(raw_data(:,6)));
  SGI = sort(unique(raw_data(:,7)));
  
  all_rates = unique(raw_data(:,[3 4 5 6 7]), 'rows');

  result = [];
  
  scrsz = [ 1 1 1200 1200 ]
  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
  set(gcf,'paperpositionmode','auto');
  set(gca,'fontsize',16);

  X_PLOT_SIZE=2;
  Y_PLOT_SIZE=3;

  for l = 1:size(LINKS,1)
  
    link_res = raw_data(find(raw_data(:,2) == LINKS(l)),:);
  
    for r = 1:size(all_rates,1)
  
      rates_res = link_res(strmatch(all_rates(r), link_res(:,3:7)),:);
  
      power_result = [ all_rates(r,1) ];  %add rate as first col to be able to sort data
      for power = 1:size(POWER,1)
        p = rates_res(find(rates_res(:,1) == POWER(power)),:);
        pdr = min(1,size(p,1)/PACKET_COUNT);
        power_result = [ power_result pdr ];
      end
      
      result = [ result ; power_result ];
      
    end

    %result
    
    subplot(Y_PLOT_SIZE,X_PLOT_SIZE,l);
    boxplot(result);
    
  
  end
          
end
