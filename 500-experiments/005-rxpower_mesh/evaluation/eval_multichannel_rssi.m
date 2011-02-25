function eval_multichannel_rssi()
  filename = 'all_results.mat';

  data = load(filename,'-ASCII');
  channels = sort(unique(data(:,1)))
  no_channels = size(channels,1)
  
  nodes = unique(data(:,3))
  no_nodes = size(nodes,1)
  
  
  links_worst_channels = zeros(no_nodes,no_nodes);
  links_channel_qualities = zeros(no_nodes,no_nodes,no_channels);
  hist_channel_qual = [];
  
  for s = 1:no_nodes
    for r = 1:no_nodes
        if r ~= s
            sender = nodes(s);
            receiver = nodes(r);
            link_data = data(find((data(:,3) == receiver) & (data(:,4) == sender)),:);
            
            for c = 1:no_channels
              channel = channels(c);
              rssi_link_data = link_data(find(link_data(:,1) == channel),5);
              
              rssi_link_data(rssi_link_data(:) > 150) = [];
              
              if size(rssi_link_data,1) > 30
                links_channel_qualities(sender,receiver,channel) = mean(rssi_link_data);
              end
            end
            
            l = links_channel_qualities(sender,receiver,:);
            
            best_channel = zeros(no_channels,2);
            best_channel(:,1) = channels;
            best_channel(:,2) = links_channel_qualities(sender,receiver,:);
            
            best_channel = best_channel(find(best_channel(:,2) ~= 0),:);
            
            if size(best_channel,1) >= 6
              best_channel = sortrows(best_channel,-2)
              hist_channel_qual = [ hist_channel_qual; best_channel(1:1,1)]; 
            end
            
            
                        
        end
    end
  end
 
  
  hist(hist_channel_qual);
  xlabel('Channel');
  ylabel('Best channel for a link');
  print('-dpng', 'rssi_histogram_best_links.png');

end
