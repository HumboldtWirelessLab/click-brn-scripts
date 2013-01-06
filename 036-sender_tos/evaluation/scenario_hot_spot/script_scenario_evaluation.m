clear all;
close all;
%file_txt = 'inrange_2.mat';%old
file_txt = 'inrange.mat';%new


number = 1; %NUM
number_of_nodes = 2; %NO_NODES (Number of neighbours nodes)
packet_size = 3; %PACKETSIZE
backoff_window_size_min = 4;%BACKOFF_Min (this will be currently evaluated)
backoff_window_size_max = 5;%BACKOFF_MAX (TODO:this values are not correct)
seed = 6; %SEED
rate = 7; %RATE
time = 8; %TIME
node = 9; %NODE
id = 10; %ID
phy_hardware_busy = 11; %PHY_HWBUSY
phy_hardware_received = 12; %PHY_HWRX
phy_hardware_transmitted = 13; %PHY_HWTX
mac_packet_received = 14; %RXPKT
mac_packet_error_crc = 15; %CRCPKT
mac_packet_error_phy = 16; %PHYPKT
mac_address_source = 17; %ADDR
rssi_value = 18; %RSSI
rssi_value_standard_deviation = 19; %STDRSSI
rssi_value_min = 20; %MINRSSI
rssi_value_max = 21; %MAXRSSI
packet_counter = 22; %PKTCNT (has to be the last element)
    
[matrix] = func_testbed_results_read(file_txt,packet_counter);
[matrix_packet_size,vector_counter_packet_size,vector_packet_sizes] = func_packet_size_filter(matrix,packet_size);
vector_neighbour_total = unique(matrix_packet_size(1,1:1:vector_counter_packet_size(1,1),mac_address_source));
vector_neighbour_all = unique(matrix_packet_size(1,1:1:vector_counter_packet_size(1,1),number_of_nodes));
matrix_evaluation_per_neighbour = zeros(size(vector_counter_packet_size,2),size(vector_neighbour_all,2),2);

%The following is needed for matrix dimensions
matrix_dimension_max = zeros(size(vector_packet_sizes,1),2);
for p=1:1:size(vector_packet_sizes,1)
    matrix_2D = func_convert_matrix_3D_2_2D(matrix_packet_size,p);
    counter = vector_counter_packet_size(1,p);
    matrix_shorten = func_matrix_shorten(matrix_2D,1,counter);
    [matrix_nodes_packet_size_byte] = func_filter_nodes(matrix_shorten,number_of_nodes,mac_address_source);
    [vector_no_neighbours_total,vector_counter_matrix_values_per_neighbour] = func_evaluation_dimensions_get(matrix_nodes_packet_size_byte,mac_address_source);
    matrix_dimension_max(p,1) = size(vector_no_neighbours_total,1);
    matrix_dimension_max(p,2) = max(vector_counter_matrix_values_per_neighbour);
end
vector_dimension = max(matrix_dimension_max);
vector_backoff_total = unique(matrix_packet_size(1,1:1:vector_counter_packet_size(1,1),backoff_window_size_min));
matrix_evaluation_per_neighbour_rssi_packet_counter = zeros(size(vector_packet_sizes,1),vector_dimension(1,1),vector_dimension(1,2),2);
matrix_evaluation_per_neighbour_no_neighbours = zeros(size(vector_packet_sizes,1),size(vector_neighbour_total,2),size(vector_neighbour_all,2));

matrix_evaluation_per_neighbour_backoff_window_sizes = zeros(size(vector_packet_sizes,1),size(vector_neighbour_total,2),size(vector_backoff_total,2));

matrix_evaluation_per_neighbour_backoff_no_packets_rx_avg = zeros(size(vector_packet_sizes,1),size(vector_neighbour_total,2),size(vector_neighbour_all,2),size(vector_backoff_total,2));

for p=1:1:size(vector_packet_sizes,1)
    matrix_2D = func_convert_matrix_3D_2_2D(matrix_packet_size,p);
    counter = vector_counter_packet_size(1,p);
    matrix_shorten = func_matrix_shorten(matrix_2D,1,counter);
    [matrix_nodes_packet_size_byte] = func_filter_nodes(matrix_shorten,number_of_nodes,mac_address_source);
    [matrix_stats_packet_size_per_neighbour] = func_stats_calculation_global(matrix_nodes_packet_size_byte,number,number_of_nodes,packet_counter);
    matrix_evaluation_per_neighbour(p,:,:) = matrix_stats_packet_size_per_neighbour(:,:);
    [matrix_rssi_packet_counter,matrix_no_neighbours_unique,matrix_backoff_window_sizes_unique,matrix_backoff_no_packets_rx_avg] = func_stats_calc_per_neighbour(matrix_nodes_packet_size_byte,mac_address_source,number_of_nodes,backoff_window_size_min,rssi_value,packet_counter);
    
    matrix_evaluation_per_neighbour_rssi_packet_counter(p,1:1:size(matrix_rssi_packet_counter,1),1:1:size(matrix_rssi_packet_counter,2),1:1:size(matrix_rssi_packet_counter,3)) = matrix_rssi_packet_counter(1:1:size(matrix_rssi_packet_counter,1),1:1:size(matrix_rssi_packet_counter,2),1:1:size(matrix_rssi_packet_counter,3));
    matrix_evaluation_per_neighbour_no_neighbours(p,1:1:size(matrix_no_neighbours_unique,1),1:1:size(matrix_no_neighbours_unique,2)) = matrix_no_neighbours_unique(1:1:size(matrix_no_neighbours_unique,1),1:1:size(matrix_no_neighbours_unique,2));
    matrix_evaluation_per_neighbour_backoff_window_sizes(p,1:1:size(matrix_backoff_window_sizes_unique,1),1:1:size(matrix_backoff_window_sizes_unique,2)) = matrix_backoff_window_sizes_unique(1:1:size(matrix_backoff_window_sizes_unique,1),1:1:size(matrix_backoff_window_sizes_unique,2));
    matrix_evaluation_per_neighbour_backoff_no_packets_rx_avg(p,1:1:size(matrix_backoff_no_packets_rx_avg,1),1:1:size(matrix_backoff_no_packets_rx_avg,2),1:1:size(matrix_backoff_no_packets_rx_avg,3)) = matrix_backoff_no_packets_rx_avg(1:1:size(matrix_backoff_no_packets_rx_avg,1),1:1:size(matrix_backoff_no_packets_rx_avg,2),1:1:size(matrix_backoff_no_packets_rx_avg,3));
end
figure_number = 1;
label_y = '\bf Pakete im Mittel empfangen';
[handler_figure_1] = func_figure_no_nodes_no_packets_rx(figure_number,matrix_evaluation_per_neighbour,label_y,vector_packet_sizes);
figure_number = figure_number  + 1;
label_y = '\bf Pakete im Mittel empfangen [KB]';
[handler_figure_2] = func_figure_no_nodes_no_packets_rx(figure_number,matrix_evaluation_per_neighbour,label_y,vector_packet_sizes);
for p=1:1:size(matrix_evaluation_per_neighbour_backoff_no_packets_rx_avg,1)
    for t=2:1:size(matrix_evaluation_per_neighbour_backoff_no_packets_rx_avg,2)  
            matrix_neighbours  = func_convert_matrix_3D_2_2D(matrix_evaluation_per_neighbour_no_neighbours,p);
            vector_neighbours = matrix_neighbours(t,:);
            matrix_backoff = func_convert_matrix_3D_2_2D(matrix_evaluation_per_neighbour_backoff_window_sizes,p);
            vector_backoff = matrix_backoff(t,:);
            [matrix_3d] = func_convert_matrix_4D_2_3D(matrix_evaluation_per_neighbour_backoff_no_packets_rx_avg,p);
            matrix_1 = func_convert_matrix_3D_2_2D(matrix_3d,t);
            figure_number = figure_number + 1;
            str_title = sprintf('Paketgröße = %d, Nachbarstation = %d',vector_packet_sizes(p,1),vector_neighbour_total(1,t-1)); 
            %func_figure_neighbours_packets_rx_per_backoff(figure_number,vector_neighbours,matrix_1, vector_backoff);
            %figure_number = figure_number + 1;
            func_figure_backoff_packets_rx_per_neighbour(figure_number,vector_backoff,matrix_1,vector_neighbours,str_title);
    end
end
obsolet = 0;
if (obsolet == 1)
    for p=1:1:size(vector_packet_sizes,1)
        for t=1:1:size(matrix_evaluation_per_neighbour_rssi_packet_counter,2)
            figure_number = figure_number  + 1;
            func_figure_scatter(figure_number,matrix_evaluation_per_neighbour_rssi_packet_counter(p,t,:,:));
        end
    end
end

