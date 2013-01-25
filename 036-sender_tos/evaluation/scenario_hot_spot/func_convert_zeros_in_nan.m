function [matrix_result] = func_convert_zeros_in_nan(matrix,vector_size_2_max)
    matrix_result = matrix;
    for i=1:1:size(matrix,1)
        matrix_result(i,vector_size_2_max(1,i):1:size(matrix_result,2)) = NaN;
    end
end

