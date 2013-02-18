function [matrix_backoff_mean,matrix_backoff_std] = func_calc_frequency_mean_std(matrix_3D,vector_no_nodes,flag_std)
    matrix_backoff_mean = zeros(size(matrix_3D,1),size(matrix_3D,3));
    matrix_backoff_std = zeros(size(matrix_3D,1),size(matrix_3D,3));
    counter = 0;
    for i = 1:1:size(matrix_3D,1) % Experiment
        matrix_station_backoff =func_convert_matrix_3D_2_2D(matrix_3D,i);
        if (size(matrix_station_backoff,1) >= vector_no_nodes(1,i))
            matrix_backoff_mean(i,:) = mean(matrix_station_backoff(1:1:vector_no_nodes(1,i),:),1);
            matrix_backoff_std(i,:) = std(matrix_station_backoff(1:1:vector_no_nodes(1,i),:),flag_std,1);
            counter = counter + 1;
        else
            matrix_backoff_mean(i,:) = 0;
            matrix_backoff_std(i,:) = 0; 
        end
    end
    if (counter < size(matrix_3D,1))
         matrix_backoff_mean = func_matrix_shorten(matrix_backoff_mean,1,counter);
         matrix_backoff_std = func_matrix_shorten(matrix_backoff_std,1,counter);
    end
end

