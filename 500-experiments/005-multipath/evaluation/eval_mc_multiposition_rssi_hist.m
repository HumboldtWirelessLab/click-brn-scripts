function eval_mc_multiposition_rssi_hist(filename,nodefilename, packet_count, node_dist)

  PLOTMAIN=0;
  PLOTCOHERENCEBW=1;

  CHANNEL_CORRELATION_TRESHOLD=0.8;
  CHANNEL_CORRELATION_RSSI_TRESHOLD=0.5;

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
  
  if isempty(node_dist)
    [nodenames nodedevices nodemacs nodeids node_dist]=textread(nodefilename,'%s %s %s %d %d')
  else
    [nodenames nodedevices nodemacs nodeids]=textread(nodefilename,'%s %s %s %d')
  end

  node_dist(node_dist == 0) = [];
  
  links=unique(raw_res(:,[8 9]),'rows');
  size(links)
  if size(links,1) < 30
    links
  end
  

  scrsz = [ 1 1 1200 1200 ]
  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])

  
  for n1 = 1:no_nodes-1  %src
    for n2 = n1:no_nodes %dst
      node1 = nodes(n1);
      node2 = nodes(n2);
      
      res=raw_res(find((raw_res(:,8)==node1) & (raw_res(:,9)==node2)),:);
      res_back=raw_res(find((raw_res(:,8)==node2) & (raw_res(:,9)==node1)),:);

      if (n1 ~= n2) & (~isempty(res)) & (~isempty(res_back))          

          for mod = 1:no_mode 
            modes_res = res(find(res(:,2) == modes(mod)),:);
            modes_res_back = res_back(find(res_back(:,2) == modes(mod)),:);
            
            modopts = unique(modes_res(:,3));
            no_modopts=size(modopts,1);

            for opt = 1:no_modopts
              data = modes_res(find(modes_res(:,3) == modopts(opt)),:);
              data_back = modes_res_back(find(modes_res_back(:,3) == modopts(opt)),:);

              for p = 1:1
                %no_positions
                pos = positions(p);

                for c = 5:5
                  %no_channel
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
                  
                  if ~isempty(rssi_data) 
                    if ~isempty(rssi_data_back)
                      set(gcf,'paperpositionmode','auto');
                      set(gca,'fontsize',16);
                     
                      hist(rssi_data, (max(rssi_data) - min(rssi_data) + 1));
                      epsfilename=strcat('./multipath_rssi_hist_',num2str(node1),'_to_',num2str(node2),'.eps')
                      saveas(gcf, epsfilename, 'eps')
                    end
                  end


                end
              end
            end
          end
      end
    end
  end
  
end
