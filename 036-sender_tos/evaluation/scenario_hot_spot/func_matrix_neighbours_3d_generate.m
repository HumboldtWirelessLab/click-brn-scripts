function [matrix_values_per_neighbour,vector_counter_matrix_values_per_neighbour] = func_matrix_neighbours_3d_generate(matrix_nodes, vector_no_neighbours_total,index_mac_address_source)
    matrix_values_per_neighbour = zeros(size(vector_no_neighbours_total,1),size(matrix_nodes,1),size(matrix_nodes,2));
    vector_counter_matrix_values_per_neighbour = zeros(1,size(vector_no_neighbours_total,1)); 
    for i= 1:1:size(matrix_nodes,1)
        %if (matrix_nodes(i,index_mac_address_source) >= 1)
            index_neighbour_pos = find(vector_no_neighbours_total == matrix_nodes(i,index_mac_address_source),1);
            if (~isempty(index_neighbour_pos))
                vector_counter_matrix_values_per_neighbour(1,index_neighbour_pos) = vector_counter_matrix_values_per_neighbour(1,index_neighbour_pos) + 1; 
                z = vector_counter_matrix_values_per_neighbour(1,index_neighbour_pos);
                matrix_values_per_neighbour(index_neighbour_pos,z,:) = matrix_nodes(i,:);
            end
    end  
end

