function [matrix_result,counter_result] = func_filter(matrix_2D,target,kind_of_target) 
    matrix_result = zeros(size(matrix_2D,1),size(matrix_2D,2));
    counter_result = 0;
    for i = 1:1:size(matrix_2D,1)
        if (matrix_2D(i,target) == kind_of_target)
            counter_result = counter_result + 1;
            matrix_result(counter_result,:) = matrix_2D(i,:);
        end
    end
    matrix_result = func_matrix_shorten(matrix_result,1,counter_result);
end




