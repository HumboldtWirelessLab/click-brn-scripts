%function [] = func_stats_calc_per_neighbour(vector_no_neighbours_total,matrix_values_per_neighbour,vector_counter_matrix_values_per_neighbour,index_no_neighbour_nodes,index_backoff,index_rssi_value,index_packet_counter) 
function [matrix_rssi_packet_counter,matrix_no_neighbours_unique,matrix_backoff_window_sizes_unique,matrix_backoff_no_packets_rx_avg_save] = func_stats_calc_per_neighbour(matrix_nodes,index_mac_address_source,index_no_neighbour_nodes,index_backoff,index_rssi_value,index_packet_counter)

    vector_no_neighbours_total = unique(matrix_nodes(:,index_mac_address_source));
    %sort values for every neighbour:
    %   matrix_values_per_neighbour[vector_no_neighbours_total][size(values_matrix_nodes,1)][size(values_matrix_nodes,2)]
    %   vector_counter_matirx_values_per_neighbour[1][vector_no_neighbours_total]
    [matrix_values_per_neighbour,vector_counter_matrix_values_per_neighbour] = func_matrix_neighbours_3d_generate(matrix_nodes, vector_no_neighbours_total,index_mac_address_source);   

    matrix_rssi_packet_counter = zeros(size(vector_no_neighbours_total,1),max(vector_counter_matrix_values_per_neighbour),2);
    
    %vector_number_of_neighbours_unique = unique(matrix_values_per_neighbour(1,:,index_no_neighbour_nodes));
    n = find(matrix_values_per_neighbour(1,:,index_no_neighbour_nodes) == 0,1);
    vector_number_of_neighbours_unique = unique(matrix_values_per_neighbour(1,1:1:n-1,index_no_neighbour_nodes));
    matrix_no_neighbours_unique = zeros(size(vector_no_neighbours_total,1),size(vector_number_of_neighbours_unique,1));
    
    n = find(matrix_values_per_neighbour(1,:,index_backoff) == 0,1);
    vector_backoff_window_sizes_unique_2  = unique(matrix_values_per_neighbour(1,1:1:n-1,index_backoff));
    matrix_backoff_window_sizes_unique = zeros(size(vector_no_neighbours_total,1),size(vector_backoff_window_sizes_unique_2,1));
    
    matrix_backoff_no_packets_rx_avg_save = zeros(size(vector_no_neighbours_total,1),size(vector_number_of_neighbours_unique,1),size(vector_backoff_window_sizes_unique_2,1));
    for i = 1:1:size(vector_no_neighbours_total,1)
        if (~isempty(find(vector_no_neighbours_total == i, 1)))
            [matrix_2d] = func_convert_matrix_3D_2_2D(matrix_values_per_neighbour,i);
            matrix_2d_shorten  = func_matrix_shorten(matrix_2d,1,vector_counter_matrix_values_per_neighbour(1,i));
        
            %matrix_rssi_packet_counter = zeros(size(matrix_2d_shorten,1),2);
            matrix_rssi_packet_counter(i,1:1:size(matrix_2d_shorten,1),1) = matrix_2d_shorten(1:1:size(matrix_2d_shorten,1),index_rssi_value);
            matrix_rssi_packet_counter(i,1:1:size(matrix_2d_shorten,1),2) = matrix_2d_shorten(1:1:size(matrix_2d_shorten,1),index_packet_counter);
        
            %figure_number = figure_number  + 1;
            %func_figure_scatter(figure_number,matrix_rssi_packet_counter);
        
            matrix_backoff_no_packets_received = zeros(size(matrix_2d_shorten,1),3);
            matrix_backoff_no_packets_received(1:1:size(matrix_2d_shorten,1),1) = matrix_2d_shorten(1:1:size(matrix_2d_shorten,1),index_no_neighbour_nodes);
            matrix_backoff_no_packets_received(1:1:size(matrix_2d_shorten,1),2) = matrix_2d_shorten(1:1:size(matrix_2d_shorten,1),index_backoff);
            matrix_backoff_no_packets_received(1:1:size(matrix_2d_shorten,1),3) = matrix_2d_shorten(1:1:size(matrix_2d_shorten,1),index_packet_counter);
        
        
            vector_no_neighbours_unique = unique(matrix_backoff_no_packets_received(:,1));%TODO
            vector_backoff_window_sizes_unique = unique(matrix_backoff_no_packets_received(:,2));%TODO
            matrix_backoff_no_packets_rx_avg = zeros(size(vector_no_neighbours_unique,1),size(vector_backoff_window_sizes_unique,1));%TODO
            matrix_counter_backoff = zeros(size(vector_no_neighbours_unique,1),size(vector_backoff_window_sizes_unique,1));
        
            for vn = 1:1:size(vector_no_neighbours_unique,1)
                for bu=1:1:size(vector_backoff_window_sizes_unique,1)
                    for b=1:1:size(matrix_backoff_no_packets_received,1)
                        if (~isempty(find(vector_no_neighbours_unique(vn,1) == matrix_backoff_no_packets_received(b,1), 1)))
                            if (~isempty(find(vector_backoff_window_sizes_unique(bu,1) == matrix_backoff_no_packets_received(b,2), 1)))
                                matrix_counter_backoff(vn,bu) = matrix_counter_backoff(vn,bu)  + 1;
                                matrix_backoff_no_packets_rx_avg(vn,bu) = matrix_backoff_no_packets_rx_avg(vn,bu) + matrix_backoff_no_packets_received(b,3);                           
                            end
                        end
                    end
                    matrix_backoff_no_packets_rx_avg(vn,bu) = matrix_backoff_no_packets_rx_avg(vn,bu) / matrix_counter_backoff(vn,bu);
                end
            end
            for s=1:1:size(vector_no_neighbours_unique,1)
                matrix_no_neighbours_unique(i,s) = vector_no_neighbours_unique(s,1);
            end
            for s=1:1:size(vector_backoff_window_sizes_unique,1)
                matrix_backoff_window_sizes_unique(i,s) = vector_backoff_window_sizes_unique(s,1);
            end
            for s=1:1:size(matrix_backoff_no_packets_rx_avg,1)
                for t=1:1:size(matrix_backoff_no_packets_rx_avg,2)
                    matrix_backoff_no_packets_rx_avg_save(i,s,t) = matrix_backoff_no_packets_rx_avg(s,t);
                end
            end
            %figure_number = figure_number + 1;
            %func_figure_backoff_packets_rx_per_neighbour(figure_number,vector_backoff_window_sizes_unique,matrix_backoff_no_packets_rx_avg,vector_no_neighbours_unique);
            %figure_number = figure_number + 1;
            %func_figure_neighbours_packets_rx_per_backoff(figure_number,vector_no_neighbours_unique,matrix_backoff_no_packets_rx_avg, vector_backoff_window_sizes_unique);
        end
    end
end

