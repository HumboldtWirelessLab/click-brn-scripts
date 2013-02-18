function [figure_number,vector_handler_figure] = func_evaluation_senders(matrix,node,number_of_nodes,backoff_window_size_min,sender_retries,str_figure_title,figure_number,flag_std,vector_station_filter,vector_backoff_filter)
    vector_senders_total = unique(matrix(:,node));
    vector_no_nodes_max_per_experiment = unique(matrix(:,number_of_nodes))'; % max number of sending nodes for this experiment
    vector_backoff_total = unique(matrix(:,backoff_window_size_min))';
    
    if (vector_station_filter == -1)
        %vector_senders_total
        vector_station_filter = vector_no_nodes_max_per_experiment;
    end
    
    if (vector_backoff_filter == -1)
        vector_backoff_total = vector_backoff_total;
    end
    
    [matrix_sender_3D,vector_counter_dim_2] = func_filter_nodes_sender(matrix,node,vector_senders_total);
    matrix_sender_result_3D_mean = zeros(size(vector_senders_total,1),size(vector_no_nodes_max_per_experiment,2),size(vector_backoff_total,2));
    matrix_sender_result_3D_sum = zeros(size(vector_senders_total,1),size(vector_no_nodes_max_per_experiment,2),size(vector_backoff_total,2));
    
    vector_pos_min = zeros(1,size(vector_senders_total,1));
    vector_handler_figure = -1;
    if (strfind(str_figure_title, 'Unicast'))
        for i = 1:1:size(vector_senders_total,1)
            matrix_sender_2D = func_convert_matrix_3D_2_2D(matrix_sender_3D,i);
            matrix_sender_2D_shorten = matrix_sender_2D(1:1:vector_counter_dim_2(1,i),:);
        
            [matrix_global_station_backoff_sender_retries_raw] = func_data_global_get(matrix_sender_2D_shorten,number_of_nodes,node,backoff_window_size_min,sender_retries);
            [matrix_data_global_station_backoff_sender_retries_mean,matrix_data_global_station_backoff_sender_retries_std] = func_reduce_dim_matrix_4D_mean(matrix_global_station_backoff_sender_retries_raw,flag_std);
            matrix_experiments_4_this_sender = min(unique(matrix_sender_2D_shorten(:,number_of_nodes)));
            pos_index_start = find(vector_no_nodes_max_per_experiment == matrix_experiments_4_this_sender);
            vector_pos_min(1,i) = pos_index_start;
            matrix_helper = zeros(size(matrix_data_global_station_backoff_sender_retries_mean,1),size(matrix_data_global_station_backoff_sender_retries_mean,3));
            matrix_helper(:,:) = matrix_data_global_station_backoff_sender_retries_mean(:,1,:);
            matrix_sender_result_3D_mean(i,pos_index_start:1:(pos_index_start + size(matrix_helper,1) - 1),1:1:size(matrix_helper,2)) = matrix_helper(1:1:size(matrix_helper,1),1:1:size(matrix_helper,2));
        
            [matrix_global_station_backoff_sender_retries] = func_reduce_dim_matrix_4D_sum(matrix_global_station_backoff_sender_retries_raw);
            matrix_helper_2 = zeros(size(matrix_global_station_backoff_sender_retries,1),size(matrix_global_station_backoff_sender_retries,3));
            matrix_helper_2(:,:) = matrix_global_station_backoff_sender_retries(:,1,:);
            matrix_sender_result_3D_sum(i,pos_index_start:1:(pos_index_start + size(matrix_helper_2,1) - 1),1:1:size(matrix_helper_2,2)) = matrix_helper_2(1:1:size(matrix_helper_2,1),1:1:size(matrix_helper_2,2));
        end
    end


    %Plot some graphs
    if (strfind(str_figure_title, 'Unicast'))
        vector_handler_figure = zeros(1,size(vector_senders_total,1) + 4);
        counter_handler = 0;
        for i = 1:1:size(vector_senders_total,1)
            matrix_sender_2D = func_convert_matrix_3D_2_2D(matrix_sender_result_3D_sum,i);
            str_title = sprintf('%s, Sender = %d (s)',str_figure_title,vector_senders_total(i,1));
            str_label_x = '\bf{Anzahl sendender Stationen}';
            str_label_y = '\bf{Anzahl von Wiederholungsversuchen}';
            vector_legend = vector_backoff_total;
            str_legend_title = '\bf{Backoff-Fenstergröße [Slots]}';
            counter_handler = counter_handler + 1;
            vector_handler_figure(1,counter_handler) = func_figure_packets_backoff_packet_counter_global_2(figure_number,vector_no_nodes_max_per_experiment(vector_pos_min(1,i):1:size(vector_no_nodes_max_per_experiment,2)),matrix_sender_2D(vector_pos_min(1,i):1:size(vector_no_nodes_max_per_experiment,2),:),str_title,str_label_x,str_label_y,vector_legend,str_legend_title);
            figure_number = figure_number + 1;
        
            str_label_x = '\bf{Backoff-Fenstergröße [Slots]}';
            str_label_y = '\bf{Anzahl von Wiederholungsversuchen}';
            vector_legend = vector_no_nodes_max_per_experiment(vector_pos_min(1,i):1:size(vector_no_nodes_max_per_experiment,2));
            str_legend_title = '\bf{Anzahl sendender Stationen}'; 
            counter_handler = counter_handler + 1;
            vector_handler_figure(1,counter_handler) = func_figure_packets_backoff_packet_counter_global_2(figure_number,vector_backoff_total,matrix_sender_2D(vector_pos_min(1,i):1:size(vector_no_nodes_max_per_experiment,2),:)',str_title,str_label_x,str_label_y,vector_legend,str_legend_title);
            figure_number = figure_number + 1;
        
            matrix_sender_2D = func_convert_matrix_3D_2_2D(matrix_sender_result_3D_mean,i);
            str_title = sprintf('%s, Sender = %d (m)',str_figure_title,vector_senders_total(i,1));
            str_label_x = '\bf{Anzahl sendender Stationen}';
            str_label_y = '\bf{Anzahl von Wiederholungsversuchen}';
            vector_legend = vector_backoff_total;
            str_legend_title = '\bf{Backoff-Fenstergröße [Slots]}'; 
            counter_handler = counter_handler + 1;
            vector_handler_figure(1,counter_handler) = func_figure_packets_backoff_packet_counter_global_2(figure_number,vector_no_nodes_max_per_experiment(vector_pos_min(1,i):1:size(vector_no_nodes_max_per_experiment,2)),matrix_sender_2D(vector_pos_min(1,i):1:size(vector_no_nodes_max_per_experiment,2),:),str_title,str_label_x,str_label_y,vector_legend,str_legend_title);
            figure_number = figure_number + 1;
        
            str_label_x = '\bf{Backoff-Fenstergröße [Slots]}';
            str_label_y = '\bf{Anzahl von Wiederholungsversuchen}';
            vector_legend = vector_no_nodes_max_per_experiment(vector_pos_min(1,i):1:size(vector_no_nodes_max_per_experiment,2));
            str_legend_title = '\bf{Anzahl sendender Stationen}';
            counter_handler = counter_handler + 1;
            vector_handler_figure(1,counter_handler) = func_figure_packets_backoff_packet_counter_global_2(figure_number,vector_backoff_total,matrix_sender_2D(vector_pos_min(1,i):1:size(vector_no_nodes_max_per_experiment,2),:)',str_title,str_label_x,str_label_y,vector_legend,str_legend_title);
            figure_number = figure_number + 1;
        end
    end
end