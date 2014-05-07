function [matrix_3D_mean,matrix_3D_std] = func_reduce_dim_matrix_4D_mean(matrix_4D,flag_std)
    matrix_3D_mean  = zeros(size(matrix_4D,1),size(matrix_4D,2),size(matrix_4D,3));
    matrix_3D_std = zeros(size(matrix_4D,1),size(matrix_4D,2),size(matrix_4D,3));
    for i = 1:1:size(matrix_4D,1)
        [matrix_3D] = func_convert_matrix_4D_2_3D(matrix_4D,i);
        for j=1:1:size(matrix_4D,2)
            matrix_station_backoff =func_convert_matrix_3D_2_2D(matrix_3D,j);
            matrix_3D_mean(i,j,:) = mean(matrix_station_backoff,2);
            matrix_3D_std(i,j,:) = std(matrix_station_backoff,flag_std,2);
        end 
    end
end

