function [matrix_3d] = func_convert_matrix_4D_2_3D(matrix_4d,dim1)
    matrix_3d = zeros(size(matrix_4d,2),size(matrix_4d,3),size(matrix_4d,4));
    matrix_3d(:,:,:) = matrix_4d(dim1,:,:,:);
end