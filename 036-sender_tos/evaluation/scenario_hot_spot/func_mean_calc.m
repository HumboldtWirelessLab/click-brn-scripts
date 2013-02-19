function [vector_result] = func_mean_calc(matrix, vector_counter_dim)
    vector_result = zeros(size(matrix,1),1);
    for i=1:1:size(matrix,1) %experiment
        for j = 1:1:size(matrix,2) %station
        vector_result(i,1) = vector_result(i,1) + matrix(i,j);
        end
        if (vector_counter_dim(1,i) > 0)
            vector_result(i,1) = vector_result(i,1) / vector_counter_dim(1,i);
        end
    end
end

