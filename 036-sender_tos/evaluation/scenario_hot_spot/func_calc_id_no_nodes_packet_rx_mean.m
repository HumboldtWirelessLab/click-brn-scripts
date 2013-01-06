function [matrix_calc,counter_calc] = func_calc_id_no_nodes_packet_rx_mean(matrix_nodes,id_number_min,id_number_max,index_id_number,index_number_of_packets,index_number_of_neighbour_nodes)
    matrix_helper = zeros(size(matrix_nodes,1),size(matrix_nodes,2));
    counter_helper = 0;
    matrix_calc = zeros(id_number_max,3);
    counter_calc = 0;  
    % Search in Matrix-Nodes for all elements with the current ID-Number     
    for i=id_number_min:1:id_number_max
        for j=1:1:size(matrix_nodes,1)
            if (i == matrix_nodes(j,index_id_number))
                counter_helper = counter_helper + 1;
                matrix_helper(counter_helper,:) = matrix_nodes(j,:);
                
            end
        end
    % If there are elements with the current ID-Number:
    % -remember: ID-Number, Number_of_nodes for that ID-Number, Mean(Packets-Received for that ID-Number) 
        if (counter_helper > 1)
            counter_calc = counter_calc + 1;
            matrix_calc(counter_calc,1) = i;
            matrix_calc(counter_calc,2) = matrix_helper(1,index_number_of_neighbour_nodes);
            matrix_calc(counter_calc,3) = mean(matrix_helper(1:1:counter_helper,index_number_of_packets));
            
            %set matrix_helper:= zero for the next round        
            matrix_helper(1:1:counter_helper,:) = 0;
            counter_helper = 0; %set counter_helper for the next round
        end
        
    end
end

