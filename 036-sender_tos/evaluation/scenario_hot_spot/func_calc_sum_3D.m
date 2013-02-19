function [matrix_3D_result] = func_calc_sum_3D(matrix_3D_1, matrix_3D_2)
    matrix_3D_result = zeros(size(matrix_3D_1,1),size(matrix_3D_1,2),size(matrix_3D_1,3));
     for i = 1:1:size(matrix_3D_1,1) % Experiment
        matrix_station_backoff_1 =func_convert_matrix_3D_2_2D(matrix_3D_1,i);
        matrix_station_backoff_2 =func_convert_matrix_3D_2_2D(matrix_3D_2,i);
        matrix_helper = matrix_station_backoff_1 + matrix_station_backoff_2;
        matrix_3D_result(i,1:1:size(matrix_helper,1),1:1:size(matrix_helper,2)) = matrix_helper(1:1:size(matrix_helper,1),1:1:size(matrix_helper,2));
     end  
end

