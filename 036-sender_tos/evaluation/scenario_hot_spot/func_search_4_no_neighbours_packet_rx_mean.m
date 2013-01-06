function [matrix] = func_search_4_no_neighbours_packet_rx_mean(vector_no_neighbours,matrix_shorten,index_no_neighbours,index_mean)
    matrix = zeros(size(vector_no_neighbours,1),2);
    counter = 1;
    counter_helper = 0;
    for i=1:1:size(vector_no_neighbours,1)
        for j=1:1:size(matrix_shorten,1)
            if (vector_no_neighbours(i,1) == matrix_shorten(j,index_no_neighbours))
                counter_helper = counter_helper + 1;
                matrix(counter,1) = vector_no_neighbours(i,1);
                matrix(counter,2) = matrix(counter,2) + matrix_shorten(j,index_mean);
            end
        end
        if (counter_helper > 0)
            matrix(counter,2) = matrix(counter,2) / counter_helper;
            counter_helper = 0;
            counter = counter + 1;
        end
    end


end

