function [matrix_result] = func_reduce_no_nodes(matrix,vector_no_nodes,vector_nodes_2_filter)
    matrix_result = zeros(size(vector_nodes_2_filter,2),size(matrix,2));
    for i = 1:1:size(vector_nodes_2_filter,2)
        pos_node = find(vector_no_nodes == vector_nodes_2_filter(1,i),1);
        if (~isempty(pos_node))
            matrix_result(i,:) = matrix(pos_node,:);
        end
    end
end

