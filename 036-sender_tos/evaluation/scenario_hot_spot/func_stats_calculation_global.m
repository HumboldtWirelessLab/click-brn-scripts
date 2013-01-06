function [matrix] = func_stats_calculation_global(matrix_nodes,id_number,number_of_neighbour_nodes,number_of_packets)
    index_matrix_id_number_min = min(matrix_nodes(:,id_number));
    index_matrix_id_number_max = max(matrix_nodes(:,id_number));
    
    %Calculate per ID:
    % 2. Mean of received packets  
    %---------  For 2. ----------------------------------------------------
    [matrix_calc,counter_calc] = func_calc_id_no_nodes_packet_rx_mean(matrix_nodes,index_matrix_id_number_min,index_matrix_id_number_max,id_number,number_of_packets,number_of_neighbour_nodes);
    [matrix_shorten] = func_matrix_shorten(matrix_calc,1,counter_calc);
    
    index_matrix_shorten_no_neighbours = 2;
    index_matrix_shorten_mean = 3;
    vector_no_neighbours = unique(matrix_shorten(:,index_matrix_shorten_no_neighbours));
    [matrix] = func_search_4_no_neighbours_packet_rx_mean(vector_no_neighbours,matrix_shorten,index_matrix_shorten_no_neighbours,index_matrix_shorten_mean);
end