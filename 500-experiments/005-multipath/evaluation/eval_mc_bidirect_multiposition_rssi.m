function eval_multichannel_multiposition_rssi(filename,nodefilename, packet_count)

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
  
  [nodenames nodedevices nodemacs nodeids]=textread(nodefilename,'%s %s %s %d')
  
  links=unique(raw_res(:,[8 9]),'rows');
  size(links)
  if size(links,1) < 30
    links
  end
  
  VIEWX=0;
  VIEWY=90;
  
  
  for n1 = 1:no_nodes-1
    for n2 = n1:no_nodes
      node1 = nodes(n1);
      node2 = nodes(n2);
      
      res=raw_res(find((raw_res(:,8)==node1) & (raw_res(:,9)==node2)),:);
      res_back=raw_res(find((raw_res(:,8)==node2) & (raw_res(:,9)==node1)),:);

      if (n1 ~= n2) & (~isempty(res)) & (~isempty(res_back))
          mesh_res = zeros(no_positions,no_channel);
          mesh_res_std = zeros(no_positions,no_channel);
          mesh_res_max = zeros(no_positions,no_channel);
          mesh_res_noise = zeros(no_positions,no_channel);
          mesh_res_back = zeros(no_positions,no_channel);
          mesh_res_std_back = zeros(no_positions,no_channel);
          mesh_res_max_back = zeros(no_positions,no_channel);
          mesh_res_noise_back = zeros(no_positions,no_channel);
          mesh_res_psr = zeros(no_positions,no_channel);
          mesh_res_psr_back = zeros(no_positions,no_channel);
          

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
                  mesh_res_psr(p,c) = size(noise_data,1)/packet_count;
                  noise_data(snr_data > 100) = [];
                  snr_data(snr_data > 100) = [];
                  rssi_data=noise_data + snr_data;

                  snr_data_back = data_back(find((data_back(:,4) == ch) & (data_back(:,5) == pos)),6);
                  noise_data_back = data_back(find((data_back(:,4) == ch) & (data_back(:,5) == pos)),7);
                  noise_data_back(snr_data_back > 100) = [];
                  mesh_res_psr_back(p,c) = size(noise_data_back,1)/packet_count;
                  snr_data_back(snr_data_back > 100) = [];
                  rssi_data_back=noise_data_back + snr_data_back;
                  
                  if ~isempty(rssi_data)
                    mesh_res(p,c)=mean(rssi_data);
                    mesh_res_std(p,c)=std(rssi_data);
                    mesh_res_max(p,c)=max(rssi_data);
                    mesh_res_noise(p,c)=mean(noise_data);
                  else
                    mesh_res(p,c)=-95;
                    mesh_res_std(p,c)=0;
                    mesh_res_max(p,c)=-95;
                    mesh_res_noise(p,c)=-95;
                  end

                  if ~isempty(rssi_data_back)
                    mesh_res_back(p,c)=mean(rssi_data_back);
                    mesh_res_std_back(p,c)=std(rssi_data_back);
                    mesh_res_max_back(p,c)=max(rssi_data_back);
                    mesh_res_noise_back(p,c)=mean(noise_data_back);
                  else
                    mesh_res_back(p,c)=-95;
                    mesh_res_std_back(p,c)=0;
                    mesh_res_max_back(p,c)=-95;
                    mesh_res_noise_back(p,c)=-95;
                  end

                end
              end
              
              if ( no_positions > 1 )
                  scrsz = [ 1 1 1200 900 ];
                  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
                  set(gcf,'paperpositionmode','auto');
                  set(gca,'fontsize',16);

                  %FORWARD
                  X_PLOT_SIZE=4;
                  Y_PLOT_SIZE=3;

                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
                  [X,Y]=meshgrid(positions,channels);
                  surf(X,Y,mesh_res');
                  title(strcat('Src: ', nodenames(node1), ' (', nodedevices(node1), ')  Dst: ', nodenames(node2), ' (', nodedevices(node2),')'));
                  xlabel('Position (0.8 cm/step)');
                  ylabel('Channel');
                  zlabel('Rssi');
                  view(VIEWX,VIEWY);
                  xlim([0 no_positions+1]);
                  ylim([0 no_channel+1]);
                  
                  %BACKWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,2);
                  [X,Y]=meshgrid(positions,channels);
                  surf(X,Y,mesh_res_back');
                  title(strcat('Src: ', nodenames(node2), ' (', nodedevices(node2), ')  Dst: ', nodenames(node1), ' (', nodedevices(node1),')'));
                  xlabel('Position (0.8 cm/step)');
                  ylabel('Channel');
                  zlabel('Rssi');
                  view(VIEWX,VIEWY);
                  xlim([0 no_positions+1]);
                  ylim([0 no_channel+1]);
                  
                  %FORWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,5);
                  boxplot(mesh_res);
                  title(strcat('RSSI vs Channel (Src: ',nodenames(node1),' Dst: ',nodenames(node2), ')'));
                  ylabel('Rssi');
                  xlabel('Channel');
                  
                  %BACKWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,6);
                  boxplot(mesh_res_back);
                  title(strcat('RSSI vs Channel (Src: ',nodenames(node2),' Dst: ',nodenames(node1), ')'));
                  ylabel('Rssi');
                  xlabel('Channel');
                  
                  %FORWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,7);
                  boxplot(mesh_res');
                  title(strcat('RSSI vs Position (Src: ',nodenames(node1),' Dst: ',nodenames(node2), ')'));
                  ylabel('Rssi');
                  xlabel('Position');
                  
                  %BACKWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,8);
                  boxplot(mesh_res_back');
                  title(strcat('RSSI vs Position (Src: ',nodenames(node2),' Dst: ',nodenames(node1), ')'));
                  ylabel('Rssi');
                  xlabel('Position');

                  
                  %Correlation
                  
                  channel_corr=corrcoef(mesh_res);
                  position_corr=corrcoef(mesh_res');
                  
                  %FORWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,3);
                  [X,Y]=meshgrid(channels,channels);
                  surf(X,Y,channel_corr');
                  title(strcat('Channel correlation (Node: ',nodenames(node1),')'));
                  xlabel('Channel');
                  ylabel('Channel');
                  zlabel('corr');
                  view(VIEWX,VIEWY);
                  xlim([0 no_channel+1]);
                  ylim([0 no_channel+1]);

                  %BACKWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,4);
                  [X,Y]=meshgrid(positions,positions);
                  surf(X,Y,position_corr');
                  title(strcat('Position correlation (Node: ',nodenames(node1),')'));
                  xlabel('Position');
                  ylabel('Position');
                  zlabel('corr');
                  view(VIEWX,VIEWY);
                  xlim([0 no_positions+1]);
                  ylim([0 no_positions+1]);

                  
                  %PSR
                  %FORWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,9);
                  [X,Y]=meshgrid(positions,channels);
                  surf(X,Y,mesh_res_psr');
                  title(strcat('PSR (Src: ',nodenames(node1),' Dst: ',nodenames(node2), ')'));
                  xlabel('Position');
                  ylabel('Channel');
                  zlabel('PSR');
                  view(VIEWX,VIEWY);
                  xlim([0 no_positions+1]);
                  ylim([0 no_channel+1]);


                  %BACKWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,10);
                  [X,Y]=meshgrid(positions,channels);
                  surf(X,Y,mesh_res_psr_back');
                  title(strcat('PSR (Src: ',nodenames(node2),' Dst: ',nodenames(node1), ')'));
                  xlabel('Position');
                  ylabel('Channel');
                  zlabel('PSR');
                  view(VIEWX,VIEWY);
                  xlim([0 no_positions+1]);
                  ylim([0 no_channel+1]);


                  %FORWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,11);
                  boxplot(mesh_res_psr');
                  title(strcat('PSR (Src: ',nodenames(node1),' Dst: ',nodenames(node2), ')'));
                  ylabel('PSR');
                  xlabel('Position');
                  
                  %BACKWARD
                  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,12);
                  boxplot(mesh_res_psr_back');
                  title(strcat('PSR (Src: ',nodenames(node2),' Dst: ',nodenames(node1), ')'));
                  ylabel('PSR');
                  xlabel('Position');

              else
                  figure
                  scatter(mesh_res,mesh_res_back);
                  limits=[ min([mesh_res';mesh_res_back']) max([mesh_res';mesh_res_back']) ]
                  xlim(limits);
                  ylim(limits);
              end
              epsfilename=strcat('./',strcat('multipath_', nodenames{node1}, '_', nodenames{node2}))
              saveas(gcf, epsfilename, 'eps')
              %print('-dpng', strcat(epsfilename, '.png'));
            end
          end
      end
    end
  end
end