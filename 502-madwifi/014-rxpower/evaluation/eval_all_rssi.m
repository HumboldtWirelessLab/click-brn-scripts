function eval_all_rssi(filename)

  res = load(filename,'-ASCII');
  mes = unique(res(:,1))
  no_m = size(mes,1)
  
  plot_res = zeros(no_m,3);
  boxplot_res = zeros(195,no_m);
  
  for i = 1:size(mes,1)
    m = res(find(res(:,1)==i),2);
    m(m>150)=[];
    size(m)
    if ( size(m,1) == 0 )
        m = zeros(210,1);
    end
    boxplot_res(:,i) = m(1:195);
    plot_res(i,1)=i;
    plot_res(i,2)=mean(m);
    plot_res(i,3)=std(m);
  end

  plot_res
  boxplot(boxplot_res)

  print('-dpng', 'rssi.png');
end
