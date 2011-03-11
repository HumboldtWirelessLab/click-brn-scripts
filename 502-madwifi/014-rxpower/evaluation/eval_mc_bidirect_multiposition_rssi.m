function eval_multichannel_multiposition_rssi(filename)

  raw_res = load(filename,'-ASCII');
  
  meas = unique(raw_res(:,1));
  no_meas = size(meas,1)

  modes = unique(raw_res(:,2));
  no_mode=size(modes,1)

  channels = sort(unique(raw_res(:,4)))
  no_channel = size(channels,1)

  positions = sort(unique(raw_res(:,5)))
  no_positions = size(positions,1)
  
  nodes = sort(unique(raw_res(:,9)));
  no_nodes = size(nodes,1)
  
  for n1 = 1:no_nodes-1
    for n2 = n1:no_nodes
      node1 = nodes(n1);
      node2 = nodes(n2);
      
      res=raw_res(find((raw_res(:,8)==node1) & (raw_res(:,9)==node2)),:);
      res_back=raw_res(find((raw_res(:,8)==node2) & (raw_res(:,9)==node1)),:);
      
      if n1 ~= n2
          mesh_res = zeros(no_positions,no_channel);
          mesh_res_std = zeros(no_positions,no_channel);
          mesh_res_max = zeros(no_positions,no_channel);
          mesh_res_noise = zeros(no_positions,no_channel);
          mesh_res_back = zeros(no_positions,no_channel);
          mesh_res_std_back = zeros(no_positions,no_channel);
          mesh_res_max_back = zeros(no_positions,no_channel);
          mesh_res_noise_back = zeros(no_positions,no_channel);

          for mod = 1:no_mode 
            modes_res = res(find(res(:,2) == modes(mod)),:);
            modes_res_back = res_back(find(res_back(:,2) == modes(mod)),:);
            
            modopts = unique(modes_res(:,3));
            no_modopts=size(modopts,1);

            for opt = 1:no_modopts
              data = modes_res(find(modes_res(:,3) == modopts(opt)),:);
              data_back = modes_res_back(find(modes_res_back(:,3) == modopts(opt)),:);

              for p = 1:no_positions
                pos = positions(p);

                for c = 1:no_channel
                  ch = channels(c);
                  snr_data = data(find((data(:,4) == ch) & (data(:,5) == pos)),6);
                  noise_data = data(find((data(:,4) == ch) & (data(:,5) == pos)),7);
                  noise_data(snr_data > 100) = [];
                  snr_data(snr_data > 100) = [];
                  rssi_data=noise_data + snr_data;

                  snr_data_back = data_back(find((data_back(:,4) == ch) & (data_back(:,5) == pos)),6);
                  noise_data_back = data_back(find((data_back(:,4) == ch) & (data_back(:,5) == pos)),7);
                  noise_data_back(snr_data_back > 100) = [];
                  snr_data_back(snr_data_back > 100) = [];
                  rssi_data_back=noise_data_back + snr_data_back;
                  
                  if size(rssi_data) ~= 0
                    mesh_res(p,c)=mean(rssi_data);
                    mesh_res_std(p,c)=std(rssi_data);
                    mesh_res_max(p,c)=max(rssi_data);
                    mesh_res_noise(p,c)=mean(noise_data);
                  else
                    mesh_res(p,c)=-60;
                    mesh_res_std(p,c)=0;
                    mesh_res_max(p,c)=-60;
                    mesh_res_noise(p,c)=-95;
                  end

                  if size(rssi_data) ~= 0
                    mesh_res_back(p,c)=mean(rssi_data_back);
                    mesh_res_std_back(p,c)=std(rssi_data_back);
                    mesh_res_max_back(p,c)=max(rssi_data_back);
                    mesh_res_noise_back(p,c)=mean(noise_data_back);
                  else
                    mesh_res_back(p,c)=-60;
                    mesh_res_std_back(p,c)=0;
                    mesh_res_max_back(p,c)=-60;
                    mesh_res_noise_back(p,c)=-95;
                  end

                end
              end
                
              scrsz = [ 1 1 500 1000 ];
              figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
              set(gcf,'paperpositionmode','auto');
              set(gca,'fontsize',16);

              X_PLOT_SIZE=1;
              Y_PLOT_SIZE=2;
              
              subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
              
              [X,Y]=meshgrid(positions,channels);
              Z=mesh_res;
              surf(X,Y,Z');
              
              title(strcat('Node1: ', num2str(floor((node1-1)/2)), ' ath', num2str(rem(node1+1,2)), ' Node2: ', num2str(floor((node2-1)/2)), ' ath', num2str(rem(node2+1,2))));
              
              hold on;
              
              subplot(Y_PLOT_SIZE,X_PLOT_SIZE,2);
              
              [X,Y]=meshgrid(positions,channels);
              Z=mesh_res_back;
              surf(X,Y,Z');
              
              title(strcat('Node1: ', num2str(floor((node2-1)/2)), ' ath', num2str(rem(node2+1,2)), ' Node2: ', num2str(floor((node1-1)/2)), ' ath', num2str(rem(node1+1,2))));

              %print('-dpng', strcat('rssi_', num2str(modes(mod)) , '_',  num2str(modopts(opt)), '.png'));
            end
          end
      end
    end
  end
end
