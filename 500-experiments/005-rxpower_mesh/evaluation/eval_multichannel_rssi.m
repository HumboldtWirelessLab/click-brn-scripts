function eval_multichannel_rssi(filename)
MIN_PDR = 20; % min. PDR for a link to be considered
TOTAL_NUM_PACKETS = 60 * 5;
%filename = 'all_results.mat';
%filename = 'wgt_results.mat';

% channel Empfangszeit Empfaenger Sender RSSI Noise
data = load(filename,'-ASCII');
% remove bogus values: 
RSSI_Max = 60;
data(data(:,5) > RSSI_Max,:) = [];
% convert RSSI to dBm
data(:,5) = convert_rssi_to_dbm_atheros(data(:,5),data(:,6));

channels = sort(unique(data(:,1)))
no_channels = size(channels,1)

nodes = unique(data(:,3))
no_nodes = size(nodes,1)

links_worst_channels = zeros(no_nodes,no_nodes);
links_channel_qualities = zeros(no_nodes,no_nodes,no_channels);
pdr_val = zeros(no_nodes,no_nodes,no_channels);
hist_channel_qual = [];
hist_channel_qual_2best = [];
hist_channel_pdr = [];
hist_channel_pdr_2best = [];
mean_rssi_vals = [];
mean_noise_vals = [];

for s = 1:no_nodes
for r = 1:no_nodes
    if r ~= s % for each link
        sender = nodes(s);
        receiver = nodes(r);
        link_data = data(find((data(:,3) == receiver) & (data(:,4) == sender)),:);

        mean_rssi_val = zeros(1,no_channels);
        mean_noise_val = zeros(1,no_channels);
        for c = 1:no_channels % for each channel
          % all packets on this link using this channel
          channel = channels(c);
          rssi_link_data = link_data(find(link_data(:,1) == channel),5);
          noise_link_data = link_data(find(link_data(:,1) == channel),6);

          %rssi_link_data(rssi_link_data(:) > 150) = [];
          pdr_val(sender,receiver,channel) = size(rssi_link_data,1);
          if (size(rssi_link_data,1) > ( (TOTAL_NUM_PACKETS) / (100 / MIN_PDR)) ) % Mind. MIN_PDR % der probes muessen angekommen sein
            links_channel_qualities(sender,receiver,channel) = mean(rssi_link_data);
            mean_rssi_val(c) = mean(rssi_link_data);
            mean_noise_val(c) = mean(noise_link_data);
          end
        end
        % only good links
        if (min(mean_rssi_val - mean_noise_val) > 0)
            mean_rssi_vals = [mean_rssi_vals; mean_rssi_val];
        end

        % best RSSI
        best_channel = zeros(no_channels,2);
        best_channel(:,1) = channels;
        best_channel(:,2) = links_channel_qualities(sender,receiver,:);

        best_channel = best_channel(find(best_channel(:,2) ~= 0),:);

        if (size(best_channel,1) >= 1)
          best_channel = sortrows(best_channel,-2);
          hist_channel_qual = [ hist_channel_qual; best_channel(1,1)];
          if (size( best_channel,1) > 1)
            hist_channel_qual_2best = [ hist_channel_qual_2best; best_channel(1:2,1)]; 
          else
            hist_channel_qual_2best = [ hist_channel_qual_2best; best_channel(1,1)]; 
          end
        end

        % best PDR
        best_pdr = zeros(no_channels,2);
        best_pdr(:,1) = channels;
        best_pdr(:,2) = pdr_val(sender,receiver,:);

        best_pdr = best_pdr(find(best_pdr(:,2) ~= 0),:);

        if size(best_pdr,1) >= 1
          best_pdr = sortrows(best_pdr,-2);
          hist_channel_pdr = [ hist_channel_pdr; best_pdr(1,1)]; 
          if (size( best_channel,1) > 1)
            hist_channel_pdr_2best = [ hist_channel_pdr_2best; best_pdr(1:2,1)]; 
          else
            hist_channel_pdr_2best = [ hist_channel_pdr_2best; best_pdr(1,1)]; 
          end
        end

    end
end
end

rssi_chan_delta = zeros(1,size(mean_rssi_vals,1));
for jj=1:size(mean_rssi_vals,1)
 rssi_chan_delta(jj) = max(mean_rssi_vals(jj,:)) - min(mean_rssi_vals(jj,:));
end

figure;
hist(hist_channel_qual);
grid on;
xlabel('Channel');
ylabel('Best RSSI for a link');
print('-dpng', 'rssi_histogram_best_links.png');

figure;
hist(hist_channel_pdr);
grid on;
xlabel('Channel');
ylabel('Best PDR for a link');
print('-dpng', 'pdr_histogram_best_links.png');

figure;
hist(hist_channel_qual_2best);
grid on;
xlabel('Channel');
ylabel('Best 2 RSSI for a link');
print('-dpng', 'rssi_histogram_best_2_links.png');

figure;
hist(hist_channel_pdr_2best);
grid on;
xlabel('Channel');
ylabel('Best 2 PDR for a link');
print('-dpng', 'pdr_histogram_best_2_links.png');

figure;
mean_rssi_vals2 = sortrows(mean_rssi_vals,14);
h = surf(mean_rssi_vals2);
colorbar;
set(h, 'EdgeColor', 'None');
xlim([1 no_channels]);
xlabel('Channel');
ylabel('#Link');
zlabel('RSSI');
print('-dpng', 'rssi_surf.png');

figure;
boxplot(mean_rssi_vals);
grid on;
xlabel('Channel');
ylabel('RSSI');
title(['No. links: ', int2str(size(mean_rssi_vals,1))]);
print('-dpng', 'rssi_bxplot.png');

figure;
hist(rssi_chan_delta, 20); 
grid on;
xlabel('RSSI delta (link on best minus worst channel)');
ylabel('Occurence');
title(['Links with a PDR of more than ', int2str(MIN_PDR), '% are considered']);
print('-dpng', 'rssi_delta_hist.png');

end