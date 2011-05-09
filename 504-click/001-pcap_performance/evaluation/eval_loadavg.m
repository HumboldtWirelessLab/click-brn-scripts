function eval_loadavg(filename)

  res = load(filename,'-ASCII');
  mes = sort(unique(res(:,1)));
  no_mes = size(mes,1);
  
  count_m = [];
  
  for i = 1:no_mes
    count_m = [ count_m ; size(res(find(res(:,1)==mes(i)),:),1)]
  end
  
  %count_m
  
  min_res=min(count_m);
  
  boxplot_res = zeros(min_res,no_mes);
  
  for i = 1:no_mes
    m = res(find(res(:,1)==mes(i)),3);
    %size(m)

    boxplot_res(:,i) = m(1:min_res);
  end

  boxplot(boxplot_res);
  xlabel('Mode: PCAP(odd) noPCAP(even)');
  ylabel('loadavg (one min)');
  ylim([0 1.0]);
  print('-dpng', 'loadavg.png');
end
