%function eval_multichannel_rssi(filename)
%  filename = 'all_results.mat';
filename='/testbedhome/testbed/tmp/measurements/rxpower_test/2011-02-25-rx_power_mesh_short/evaluation/all_results.mat';
  data = load(filename,'-ASCII');
  channels = sort(unique(data(:,1)))
  no_channels = size(channels,1)

  nodes = unique(data(:,3))
  no_nodes = size(nodes,1)

  p_interval_ms = 200; 

  links_worst_channels = zeros(no_nodes,no_nodes);
  links_channel_qualities = zeros(no_nodes,no_nodes,no_channels);
  links_channel_qualities_diff = zeros(no_nodes,no_nodes,no_channels);
  hist_channel_qual = [];
  links_channel_qualities_hist = zeros(no_nodes,no_channels);


  for s = 1:no_nodes
    s
    for r = 1:no_nodes
        if r ~= s
            sender = nodes(s);
            receiver = nodes(r);
            link_data = data(find((data(:,3) == receiver) & (data(:,4) == sender)),:);

            for c = 1:no_channels
              channel = channels(c);
              pdr_link_data = link_data(find(link_data(:,1) == channel),2);

              if ~isempty(pdr_link_data)
                if size(pdr_link_data,1) > 2
                  timediff=(max(pdr_link_data(:))-min(pdr_link_data(:))) / 1000;
                  wanted_p = timediff / p_interval_ms;
                  pdr = size(pdr_link_data,1) / wanted_p;
                  if pdr > 1
                    if size(pdr_link_data,1) < 20
                      pdr = 0;
                    else
                      pdr = 1;
                    end
                  end
                  links_channel_qualities(s,r,c) = pdr;
                end
              end

            end
        end
    end
  end

  pdr_sc = [];
  pdr_hist = [];

  for s = 1:(no_nodes-1)
    for r = s:no_nodes
      for c = 1:no_channels
        if ( links_channel_qualities(s,r,c) ~= 0 ) && ( links_channel_qualities(r,s,c) ~= 0 )
          pdr_sc = [ pdr_sc; sort([links_channel_qualities(s,r,c) links_channel_qualities(r,s,c)]) ];
          pdr_hist = [ pdr_hist; links_channel_qualities(s,r,c) - links_channel_qualities(r,s,c) ]
        end
      end
    end
  end

  scatter(pdr_sc(:,1),pdr_sc(:,2));
  
 % hist(hist_channel_qual);
  %xlabel('Channel');
  %ylabel('Best channel for a link');
  %print('-dpng', 'rssi_histogram_best_links.png');

%end
