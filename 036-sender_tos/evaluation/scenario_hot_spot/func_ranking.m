function [matrix_ranking,matrix_nodes] = func_ranking(matrix)
    matrix_ranking = zeros(size(matrix,1),size(matrix,2));
    matrix_nodes = zeros(size(matrix,1),size(matrix,2));
    matrix_sort_helper = zeros(2,size(matrix,2));
    for i = 1:1:size(matrix,1)
        matrix_sort_helper(1,:) = matrix(i,:);
        vector_helper = 1:1:size(matrix_sort_helper,2);
        matrix_sort_helper(2,:) = vector_helper(1,:);
        [d,ind] = sort(matrix_sort_helper,2,'descend');
        d(2,:) = matrix_sort_helper(2,ind(1,:));
        matrix_ranking(i,:) = d(1,:);
        matrix_nodes(i,:) = d(2,:);
    end
end
