function eval_multichannel_multiposition_rssi(filename)

  res = load(filename,'-ASCII');
  meas = unique(res(:,1))
  no_meas = size(meas,1)

  modes = unique(res(:,2));
  no_mode=size(modes,1);

  positions = sort(unique(res(:,7)));
  no_positions = size(positions,1);

  channels = sort(unique(res(:,4)))
  no_channel = size(channels,1)

  mesh_res = zeros(no_positions,no_channel);
  mesh_res_std = zeros(no_positions,no_channel);
  mesh_res_max = zeros(no_positions,no_channel);
  mesh_res_noise = zeros(no_positions,no_channel);

  for mod = 1:no_mode 
    modes_res = res(find(res(:,2) == modes(mod)),:);
    modopts = unique(modes_res(:,3));
    no_modopts=size(modopts,1);

    for opt = 1:no_modopts
      data = modes_res(find(modes_res(:,3) == modopts(opt)),:);

      for p = 1:no_positions
        pos = positions(p);

        for c = 1:no_channel
           ch = channels(c)
           snr_data = data(find((data(:,4) == ch) & (data(:,7) == pos)),5);
           noise_data = data(find((data(:,4) == ch) & (data(:,7) == pos)),6);
           noise_data(snr_data > 80) = [];
           snr_data(snr_data > 80) = [];
           rssi_data=noise_data + snr_data;
           mesh_res(p,c)=mean(rssi_data);
           mesh_res_std(p,c)=std(rssi_data);
           mesh_res_max(p,c)=max(rssi_data);
           mesh_res_noise(p,c)=mean(noise_data);
           
           
        end

      end

      size(positions)
      size(channels)
      size(mesh_res)
      [X,Y]=meshgrid(positions,channels);

      Z=mesh_res;
      surf(X,Y,Z');
      
      figure;
      
      Z=mesh_res_std;
      surf(X,Y,Z');

      figure;
      
      Z=mesh_res_max;
      surf(X,Y,Z');
  
      figure;
      
      Z=mesh_res_noise;
      surf(X,Y,Z');
%      print('-dpng', strcat('rssi_', num2str(modes(mod)) , '_',  num2str(modopts(opt)), '.png'));

    end
  end
end
