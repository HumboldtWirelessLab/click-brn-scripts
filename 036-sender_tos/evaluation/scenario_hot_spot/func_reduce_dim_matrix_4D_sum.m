function [matrix_3D] = func_reduce_dim_matrix_4D_sum(matrix_4D)
    matrix_3D = sum(matrix_4D,4);
end

