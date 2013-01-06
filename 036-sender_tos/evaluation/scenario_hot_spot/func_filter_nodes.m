function [matrix_new] = func_filter_nodes(matrix,number_of_neighbour_nodes,mac_address_source) % func_filter_nodes(matrix)
%matrix = [id_number, number_of_neighbour_nodes,packet_size,backoff_window_size_current, backoff_window_size_max, mac_address_source,
%          rssi_value,rssi_value_standard_deviation, rssi_value_min, rssi_value_max, packet_counter, 
%          mac_packet_received, mac_packet_error_crc, mac_packet_error_phy]; 
    vector_neighbours_out_of_experiment = zeros(size(matrix,1),1);
    counter_neighbours_out_of_experiment = 0;
    %index_number_of_neighobur_nodes = 2;
    %index_mac_address_source = 6;
    for i=1:1:size(matrix,1)
        if (matrix(i,mac_address_source) > (matrix(i,number_of_neighbour_nodes) + 1))
            counter_neighbours_out_of_experiment = counter_neighbours_out_of_experiment + 1;
            vector_neighbours_out_of_experiment(counter_neighbours_out_of_experiment,1) = i;
            
        end 
    end
    matrix_new = zeros((size(matrix,1) - counter_neighbours_out_of_experiment), size(matrix,2));
    counter_new = 0;
    for i=1:1:size(matrix,1)
        if (isempty(find(vector_neighbours_out_of_experiment == i, 1)))
            counter_new = counter_new + 1;
            matrix_new(counter_new,:) = matrix(i,:);
        end
    end
end

    %for i=1:1:size(matrix,1)
    %    %if (isempty(find(vector_neighbours_out_of_experiment == i, 1)))
    %    if (matrix(i,mac_address_source) > (matrix(i,number_of_neighobur_nodes) + 1))
    %        vector_neighbours_out_of_experiment_2(counter_neighbours_out_of_experiment_2,1) = i;
    %        counter_neighbours_out_of_experiment_2 = counter_neighbours_out_of_experiment_2 + 1;
    %    else
    %        matrix_new(counter_new,:) = matrix(i,:);
    %        counter_new = counter_new + 1;
    %    end
    %end