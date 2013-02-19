function [matrix_sender,matrix_receiver] = func_filter_sender_receiver(matrix,node)
    matrix_filter_receiver_long = zeros(size(matrix,1),size(matrix,2));
    matrix_filter_sender_long = zeros(size(matrix,1),size(matrix,2));
    counter_matrix_filter_receiver = 0;
    counter_matrix_filter_sender = 0;
    %filter nach empfänger
    for i=1:1:size(matrix,1)
        if (matrix(i,node) == 1) % ist der Empfänger
            counter_matrix_filter_receiver = counter_matrix_filter_receiver + 1;
            matrix_filter_receiver_long(counter_matrix_filter_receiver,:) = matrix(i,:);
        else
            counter_matrix_filter_sender = counter_matrix_filter_sender + 1;
            matrix_filter_sender_long(counter_matrix_filter_sender,:) = matrix(i,:);
        end
    end
    matrix_receiver = func_matrix_shorten(matrix_filter_receiver_long,1,counter_matrix_filter_receiver);
    matrix_sender = func_matrix_shorten(matrix_filter_sender_long,1,counter_matrix_filter_sender);
end


