function [vector_no_neighbours_total,vector_counter_matrix_values_per_neighbour] = func_evaluation_dimensions_get(matrix_nodes,index_mac_address_source)
    vector_no_neighbours_total = unique(matrix_nodes(:,index_mac_address_source));
    %sort values for every neighbour:
    %   matrix_values_per_neighbour[vector_no_neighbours_total][size(values_matrix_nodes,1)][size(values_matrix_nodes,2)]
    %   vector_counter_matirx_values_per_neighbour[1][vector_no_neighbours_total]
    [matrix_values_per_neighbour,vector_counter_matrix_values_per_neighbour] = func_matrix_neighbours_3d_generate(matrix_nodes, vector_no_neighbours_total,index_mac_address_source); 
end

