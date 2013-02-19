function [matrix_result] = func_data_global_get(matrix_nodes,index_number_of_nodes_total,index_mac_address_source,index_backoff_window_size,index_result)
    vector_no_nodes_max_per_experiment = unique(matrix_nodes(:,index_number_of_nodes_total));
    vector_no_station_total = unique(matrix_nodes(:,index_mac_address_source)); 
    vector_backoff_window_sizes_total = unique(matrix_nodes(:,index_backoff_window_size)); 
    matrix_result_raw = zeros(size(vector_no_nodes_max_per_experiment,1),size(vector_no_station_total,1),size(vector_backoff_window_sizes_total,1),size(matrix_nodes,1));
    matrix_counter_result = zeros(size(vector_no_nodes_max_per_experiment,1),size(vector_no_station_total,1),size(vector_backoff_window_sizes_total,1));
    for z = 1:1:size(matrix_nodes,1) % for each part of the experiment
        index_pos_part_of_experiment = find(vector_no_nodes_max_per_experiment == matrix_nodes(z,index_number_of_nodes_total),1); 
        index_pos_station = find(vector_no_station_total == matrix_nodes(z,index_mac_address_source),1);
        index_pos_backoff = find(vector_backoff_window_sizes_total == matrix_nodes(z,index_backoff_window_size),1);
        matrix_counter_result(index_pos_part_of_experiment,index_pos_station,index_pos_backoff) = matrix_counter_result(index_pos_part_of_experiment,index_pos_station,index_pos_backoff) + 1;
        matrix_result_raw(index_pos_part_of_experiment,index_pos_station,index_pos_backoff,matrix_counter_result(index_pos_part_of_experiment,index_pos_station,index_pos_backoff)) = matrix_nodes(z,index_result);
    end
    size_dim_4_max = max(max(max(matrix_counter_result)));
    [matrix_result] = func_matrix_shorten(matrix_result_raw,4,size_dim_4_max);
end

