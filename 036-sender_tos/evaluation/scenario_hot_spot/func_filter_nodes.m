function [matrix_new] = func_filter_nodes(matrix_2D,number_of_nodes,mac_address_source) 
    vector_no_nodes_max_per_experiment = unique(matrix_2D(:,number_of_nodes)); % max number of sending nodes for this experiment
    no_nodes_max = max(vector_no_nodes_max_per_experiment) + 1; % receiver has always number 1 and sender number := [2,no_nodes_max]
    matrix_result = zeros(size(matrix_2D,1),size(matrix_2D,2));
    counter_result = 0;
    for i = 1:1:size(matrix_2D,1)
        if (matrix_2D(i,mac_address_source) <= no_nodes_max)
            counter_result = counter_result + 1;
            matrix_result(counter_result,:) = matrix_2D(i,:);
        end
    end
    matrix_new = func_matrix_shorten(matrix_2D,1,counter_result);
end

