function eval_multichannel_rssi(filename)

  res = load(filename,'-ASCII');
  meas = unique(res(:,1))
  no_meas = size(meas,1)

  modes = unique(res(:,2));
  no_mode=size(modes,1);

  for mod = 1:no_mode 
    modes_res = res(find(res(:,2) == modes(mod)),:);
    modopts = unique(modes_res(:,3));
    no_modopts=size(modopts,1);

    for opt = 1:no_modopts
      data = modes_res(find(modes_res(:,3) == modopts(opt)),:);

      channels = sort(unique(data(:,4)))
      no_channel = size(channels,1)

      max_c = size(data(find(data(:,4) == channels(1)),:),1)
      for c = 2:no_channel
        size(data(find(data(:,4) == channels(c)),:),1)
        if size(data(find(data(:,4) == channels(c)),:),1) < max_c
            max_c = size(data(find(data(:,4) == channels(c)),:),1)
        end
      end


      plot_res = zeros(no_channel,3);
      boxplot_res = zeros(max_c,no_channel);

      for c = 1:no_channel
         ch = channels(c)
         rssi_data = data(find(data(:,4) == ch),5);
         rssi_data(rssi_data>150)=0;
         size(rssi_data)
         size(boxplot_res)
         boxplot_res(:,c) = rssi_data(1:max_c); 
         plot_res(c,1)=ch;
         plot_res(c,2)=mean(rssi_data);
         plot_res(c,3)=std(rssi_data);
      end

      boxplot(boxplot_res)
      ylim([-3 80]);
      print('-dpng', strcat('rssi_', num2str(modes(mod)) , '_',  num2str(modopts(opt)), '.png'));

    end
  end
  

end
