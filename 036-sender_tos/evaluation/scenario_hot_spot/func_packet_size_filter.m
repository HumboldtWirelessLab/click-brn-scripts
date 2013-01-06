function [matrix_packet_size,vector_counter_packet_size,vector_packet_sizes_unique] = func_packet_size_filter(matrix,packet_size)
    vector_packet_sizes = matrix(:,packet_size);
    vector_packet_sizes_unique = unique(vector_packet_sizes);
    matrix_packet_size = zeros(size(vector_packet_sizes_unique,1),size(matrix,1),size(matrix,2));
    vector_counter_packet_size = zeros(1,size(vector_packet_sizes_unique,1));
    for i = 1:1:size(matrix,1)
        for j = 1:1:size(vector_packet_sizes_unique,1)
            if (vector_packet_sizes_unique(j,1) == matrix(i,packet_size))
                vector_counter_packet_size(1,j) = vector_counter_packet_size(1,j) + 1;
                matrix_packet_size(j,vector_counter_packet_size(1,j),:) = matrix(i,:);
            end
        end
    end
end

