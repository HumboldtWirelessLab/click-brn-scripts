function [matrix_shorten] = func_matrix_shorten(matrix,dimension,size_new)
    if (dimension == 1)
        matrix_shorten = matrix(1:1:size_new,:);
    elseif (dimension == 2)
        matrix_shorten = matrix(:,1:1:size_new);
    elseif (dimension == 3)
        matrix_shorten = matrix(:,:,1:1:size_new);
    elseif (dimension == 4)
        matrix_shorten = matrix(:,:,:,1:1:size_new);
    else
        matrix_shorten = zeros(1,1);
    end
end

