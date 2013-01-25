function [matrix_sender,vector_counter_dim_2] = func_filter_nodes_sender(matrix,node,vector_senders)
    matrix_filter_sender_long = zeros(size(vector_senders,1),size(matrix,1),size(matrix,2));
    vector_counter_dim_2 = zeros(1,size(vector_senders,1));
    %filter nach verschiedenen Sendern
    for i=1:1:size(matrix,1)
        pos = find(vector_senders == matrix(i,node),1); 
        if (~isempty(pos)) % ist der Sender in vector_senders
            vector_counter_dim_2(1,pos) = vector_counter_dim_2(1,pos) + 1;
            matrix_filter_sender_long(pos,vector_counter_dim_2(1,pos),:) = matrix(i,:);
        end
    end
    counter_max = max(vector_counter_dim_2);
    matrix_sender = matrix_filter_sender_long(:,1:1:counter_max,:);
    %matrix_sender = func_matrix_shorten(matrix_filter_sender_long,2,counter_max);
end
