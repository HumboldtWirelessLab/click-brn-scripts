function [figure_number,vector_handler_figure] = func_evaluation_receiver(matrix,packet_size,mac_address_source,number_of_nodes,packet_counter,backoff_window_size_min,mac_packet_received,mac_packet_error_crc,mac_packet_error_phy,rssi_value,rssi_value_standard_deviation,phy_hardware_busy,phy_hardware_received,missed_sequence_number,str_figure,figure_number,flag_std,vector_station_filter,vector_backoff_filter)
    
    vector_no_nodes_max_per_experiment = unique(matrix(:,number_of_nodes))'; % max number of sending nodes for this experiment
    vector_backoff_total = unique(matrix(:,backoff_window_size_min))';
    vector_nodes_total = unique(matrix(:,mac_address_source))';% nodes, seen from the receiver, because the receiver has received a packet of the nodes

    [matrix_global_station_backoff_packets_raw] = func_data_global_bytes(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,packet_size,packet_counter);
    [matrix_global_station_backoff_packets] = func_reduce_dim_matrix_4D_sum(matrix_global_station_backoff_packets_raw);
    [matrix_evaluation_global_backoff_bytes_mean,matrix_evaluation_global_backoff_bytes_std] = func_calc_frequency_mean_std(matrix_global_station_backoff_packets,vector_no_nodes_max_per_experiment,flag_std);
    
    [matrix_global_station_backoff_rssi_raw] = func_data_global_get(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,rssi_value);
    [matrix_data_global_station_backoff_rssi_mean,matrix_data_global_station_backoff_rssi_std] = func_reduce_dim_matrix_4D_mean(matrix_global_station_backoff_rssi_raw,flag_std);
    [matrix_evaluation_global_rssi_mean,matrix_evaluation_global_rssi_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_rssi_mean,vector_no_nodes_max_per_experiment,flag_std);
    
    [matrix_global_station_backoff_phy_hardware_busy_raw] = func_data_global_get(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,phy_hardware_busy);
    [matrix_data_global_station_backoff_phy_hardware_busy_mean,matrix_data_global_station_backoff_phy_hardware_busy_std] = func_reduce_dim_matrix_4D_mean(matrix_global_station_backoff_phy_hardware_busy_raw,flag_std);
    [matrix_evaluation_global_phy_hardware_busy_mean,matrix_evaluation_global_phy_hardware_busy_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_phy_hardware_busy_mean,vector_no_nodes_max_per_experiment,flag_std);
        
    [matrix_global_station_backoff_phy_hardware_received_raw] = func_data_global_get(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,phy_hardware_received);
    [matrix_data_global_station_backoff_phy_hardware_received_mean,matrix_data_global_station_backoff_phy_hardware_received_std] = func_reduce_dim_matrix_4D_mean(matrix_global_station_backoff_phy_hardware_received_raw,flag_std);
    [matrix_evaluation_global_phy_hardware_received_mean,matrix_evaluation_global_phy_hardware_received_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_phy_hardware_received_mean,vector_no_nodes_max_per_experiment,flag_std);
    
    [matrix_rssi_ranking,matrix_rssi_ranking_nodes] = func_ranking(matrix_evaluation_global_rssi_mean');%, vector_nodes_total);
    [matrix_packet_ranking,matrix_packet_ranking_nodes] = func_ranking(matrix_evaluation_global_backoff_bytes_mean');%, vector_nodes_total);
    
    
    [matrix_global_station_backoff_rssi_std_raw] = func_data_global_get(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,rssi_value_standard_deviation);
    [matrix_data_global_station_backoff_rssi_std_value_mean,matrix_data_global_station_backoff_rssi_std_value_std] = func_reduce_dim_matrix_4D_mean(matrix_global_station_backoff_rssi_std_raw,flag_std);
    [matrix_evaluation_global_rssi_std_value_mean,matrix_evaluation_global_rssi_std_value_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_rssi_std_value_mean,vector_no_nodes_max_per_experiment,flag_std);

    [matrix_global_station_backoff_mac_packet_received_raw] = func_data_global_bytes(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,packet_size, mac_packet_received);
    [matrix_data_global_station_backoff_mac_packet_received_sum] =  func_reduce_dim_matrix_4D_sum(matrix_global_station_backoff_mac_packet_received_raw);
    [matrix_evaluation_global_mac_packet_received_mean,matrix_evaluation_global_mac_packet_received_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_mac_packet_received_sum,vector_no_nodes_max_per_experiment,flag_std);

    [matrix_global_station_backoff_mac_packet_error_crc_raw] = func_data_global_get(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,rssi_value_standard_deviation);
    [matrix_data_global_station_backoff_mac_packet_error_crc_mean,matrix_data_global_station_backoff_mac_packet_error_crc_std] = func_reduce_dim_matrix_4D_mean(matrix_global_station_backoff_mac_packet_error_crc_raw,flag_std);
    [matrix_evaluation_global_mac_packet_error_crc_mean,matrix_evaluation_global_mac_packet_error_crc_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_mac_packet_error_crc_mean,vector_no_nodes_max_per_experiment,flag_std);
     
    [matrix_global_station_backoff_mac_packet_error_phy_raw] = func_data_global_get(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,rssi_value_standard_deviation);
    [matrix_data_global_station_backoff_mac_packet_error_phy_mean,matrix_data_global_station_backoff_mac_packet_error_phy_std] = func_reduce_dim_matrix_4D_mean(matrix_global_station_backoff_mac_packet_error_phy_raw,flag_std);
    [matrix_evaluation_global_mac_packet_error_phy_mean,matrix_evaluation_global_mac_packet_error_phy_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_mac_packet_error_phy_mean,vector_no_nodes_max_per_experiment,flag_std);

    matrix_evaluation_global_mac_packet_error_phy_crc_sum_mean = matrix_evaluation_global_mac_packet_error_crc_mean + matrix_evaluation_global_mac_packet_error_phy_mean; % Additivität des Erwartungswertes; siehe z. B. Basler, S.99
    matrix_evaluation_global_mac_packet_error_phy_crc_sum_std = matrix_evaluation_global_mac_packet_error_crc_std + matrix_evaluation_global_mac_packet_error_phy_std; % eingeschränkte Additivität der Varianz; siehe z. B. Basler, S.99
    
    [matrix_data_global_station_backoff_mac_packet_error_crc_phy_mea] = func_calc_sum_3D(matrix_data_global_station_backoff_mac_packet_error_phy_mean, matrix_data_global_station_backoff_mac_packet_error_crc_mean);
    [matrix_evaluation_global_mac_packet_error_crc_phy_mean,matrix_evaluation_global_mac_packet_error_crc_phy_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_mac_packet_error_crc_phy_mea,vector_no_nodes_max_per_experiment,flag_std);

    [matrix_global_station_backoff_missed_sequence_number_raw] = func_data_global_get(matrix,number_of_nodes,mac_address_source,backoff_window_size_min,missed_sequence_number);
    [matrix_data_global_station_backoff_missed_sequence_number_mean,matrix_data_global_station_backoff_missed_sequence_number_std] = func_reduce_dim_matrix_4D_mean(matrix_global_station_backoff_missed_sequence_number_raw,flag_std);
    [matrix_evaluation_global_missed_sequence_number_mean,matrix_evaluation_global_missed_sequence_number_std] = func_calc_frequency_mean_std(matrix_data_global_station_backoff_missed_sequence_number_mean,vector_no_nodes_max_per_experiment,flag_std);
    
    [matrix_global_station_backoff_missed_sequence_number] = func_reduce_dim_matrix_4D_sum(matrix_global_station_backoff_missed_sequence_number_raw);
    [matrix_evaluation_global_missed_sequence_number_sum_mean,matrix_evaluation_global_missed_sequence_number_sum_std] = func_calc_frequency_mean_std(matrix_global_station_backoff_missed_sequence_number,vector_no_nodes_max_per_experiment,flag_std);

    %Plot some graphs
    %define vector_handler_figure
    vector_handler_figure = zeros(1,13); 
    counter_handler_figure = 0;
    
    str_title = sprintf('%s, Global',str_figure);
    str_legend_title = '\bf{Anzahl sendender Stationen}';
    str_label_y = '\bf{Anzahl der empfangenen Bytes}';
    str_label_x = '\bf{Backoff}';
    counter_handler_figure = counter_handler_figure + 1;
    [vector_handler_figure(1,counter_handler_figure)] = func_figure_errorbar_line(figure_number,vector_backoff_total,matrix_evaluation_global_backoff_bytes_mean,matrix_evaluation_global_backoff_bytes_std,vector_no_nodes_max_per_experiment,str_title,str_legend_title,str_label_y,str_label_x);
    
    figure_number = figure_number  + 1;
    str_title = sprintf('%s, mac-recv',str_figure);
    str_legend_title = '\bf{Anzahl sendender Stationen}';
    str_label_y = '\bf{Anzahl der empfangenen Bytes}';
    str_label_x = '\bf{Backoff}';
    counter_handler_figure = counter_handler_figure + 1;
    [vector_handler_figure(1,counter_handler_figure)] = func_figure_errorbar_line(figure_number,vector_backoff_total, matrix_evaluation_global_mac_packet_received_mean,matrix_evaluation_global_mac_packet_received_std,vector_no_nodes_max_per_experiment,str_title,str_legend_title,str_label_y,str_label_x);
    
    
    figure_number = figure_number  + 1;
    str_title = sprintf('%s, Mittel',str_figure);
    str_legend_title = '\bf{Anzahl sendender Stationen}';
    str_label_y = '\bf{Anzahl verlorengegangener Sequenznummern}';
    str_label_x = '\bf{Backoff}';
    vector_nodes_2_filter = vector_station_filter; 
    [matrix_evaluation_global_missed_sequence_number_mean_1] = func_reduce_no_nodes(matrix_evaluation_global_missed_sequence_number_mean, vector_no_nodes_max_per_experiment,vector_nodes_2_filter);
    [matrix_evaluation_global_missed_sequence_number_std_1] = func_reduce_no_nodes(matrix_evaluation_global_missed_sequence_number_std, vector_no_nodes_max_per_experiment,vector_nodes_2_filter);
    vector_legend = vector_nodes_2_filter; 
    counter_handler_figure = counter_handler_figure + 1;
    [vector_handler_figure(1,counter_handler_figure)] = func_figure_errorbar_line(figure_number,vector_backoff_total,matrix_evaluation_global_missed_sequence_number_mean_1,matrix_evaluation_global_missed_sequence_number_std_1 ,vector_legend,str_title,str_legend_title,str_label_y,str_label_x);
    
    figure_number = figure_number  + 1;
    str_title = sprintf('%s, Summe',str_figure);
    str_legend_title = '\bf{Anzahl sendender Stationen}';
    str_label_y = '\bf{Anzahl verlorengegangener Sequenznummern}';
    str_label_x = '\bf{Backoff}';
    vector_nodes_2_filter = vector_station_filter;
    [matrix_evaluation_global_missed_sequence_number_sum_mean_2] = func_reduce_no_nodes(matrix_evaluation_global_missed_sequence_number_sum_mean, vector_no_nodes_max_per_experiment,vector_nodes_2_filter);
    [matrix_evaluation_global_missed_sequence_number_sum_std_2] = func_reduce_no_nodes(matrix_evaluation_global_missed_sequence_number_sum_std, vector_no_nodes_max_per_experiment,vector_nodes_2_filter);
    vector_legend = vector_nodes_2_filter; 
    counter_handler_figure = counter_handler_figure + 1;
    [vector_handler_figure(1,counter_handler_figure)] = func_figure_errorbar_line(figure_number,vector_backoff_total,matrix_evaluation_global_missed_sequence_number_sum_mean_2,matrix_evaluation_global_missed_sequence_number_sum_std_2 ,vector_legend,str_title,str_legend_title,str_label_y,str_label_x);
    

    for ba= 1:1:size(vector_backoff_filter,2)
        figure_number = figure_number + 1;
        backoff_window_size_2_plot = vector_backoff_filter(1,ba);
        str_title =  sprintf('%s, Backoff-Fenstergröße %d',str_figure,backoff_window_size_2_plot);
        str_label_y = '\bf{Anzahl der empfangenen Bytes}';
        str_label_x = '\bf{Anzahl sendender Stationen}';
        pos_backoff_window_size = find(vector_backoff_total == backoff_window_size_2_plot,1);
        ma = matrix_global_station_backoff_packets(:,:,pos_backoff_window_size);
        diff_2_1 = min(vector_nodes_total) - 1; % to see, how are the starting conditions
        ma_2 = ma(1:1:size(ma,2) - diff_2_1,:);
        [matrix_result] = func_convert_zeros_in_nan(ma_2,vector_nodes_total+diff_2_1);
        counter_handler_figure = counter_handler_figure + 1;
        [vector_handler_figure(1,counter_handler_figure)] = func_figure_boxplot(figure_number,matrix_result',str_title,str_label_y,str_label_x);
    end
    
    figure_number = figure_number  + 1;
    str_title = sprintf('%s, CRC + PHY',str_figure);
    str_legend_title = '\bf{Anzahl sendender Stationen}';
    str_label_y = '\bf{Anzahl der Pakete}';
    str_label_x = '\bf{Backoff}';
    counter_handler_figure = counter_handler_figure + 1;
    [vector_handler_figure(1,counter_handler_figure)] = func_figure_errorbar_line(figure_number,vector_backoff_total,  matrix_evaluation_global_mac_packet_error_crc_phy_mean,matrix_evaluation_global_mac_packet_error_crc_phy_std,vector_no_nodes_max_per_experiment,str_title,str_legend_title,str_label_y,str_label_x);
    
    figure_number = figure_number  + 1;
    str_title = sprintf('%s, CRC+PHY(eing.)',str_figure);
    str_legend_title = '\bf{Anzahl sendender Stationen}';
    str_label_y = '\bf{Anzahl der Pakete}';
    str_label_x = '\bf{Backoff}';
    counter_handler_figure = counter_handler_figure + 1;
    [vector_handler_figure(1,counter_handler_figure)] = func_figure_errorbar_line(figure_number,vector_backoff_total,  matrix_evaluation_global_mac_packet_error_phy_crc_sum_mean,matrix_evaluation_global_mac_packet_error_phy_crc_sum_std,vector_no_nodes_max_per_experiment,str_title,str_legend_title,str_label_y,str_label_x);
       
    figure_number = figure_number  + 1;
    str_title = sprintf('%s, Backoff-Fenstergröße von %d',str_figure, vector_backoff_total(1,size(vector_backoff_total,2)));
    str_label_x = 'Anzahl sendender Stationen';
    str_label_y = 'RSSI-Werte';
    counter_handler_figure = counter_handler_figure + 1;
    [vector_handler_figure(1,counter_handler_figure)] = func_figure_errorbar(figure_number,vector_no_nodes_max_per_experiment,matrix_evaluation_global_rssi_mean(:,size(vector_backoff_total,2)),matrix_evaluation_global_rssi_std(:,size(vector_backoff_total,2)),str_title, str_label_x, str_label_y);
    
    figure_number = figure_number  + 1;
    str_title = sprintf('%s, Backoff-Fenstergröße von %d (hw)',str_figure, vector_backoff_total(1,size(vector_backoff_total,2)));
    str_label_x = 'Anzahl sendender Stationen';
    str_label_y = 'RSSI-Werte';
    counter_handler_figure = counter_handler_figure + 1;
    [vector_handler_figure(1,counter_handler_figure)] = func_figure_errorbar(figure_number,vector_no_nodes_max_per_experiment,matrix_evaluation_global_rssi_mean(:,size(vector_backoff_total,2)),matrix_evaluation_global_rssi_std_value_mean(:,size(vector_backoff_total,2)),str_title, str_label_x, str_label_y);
    
    
    for ba= 1:1:size(vector_backoff_filter,2)
        figure_number = figure_number + 1;
        number_backoff_window_size = vector_backoff_filter(1,ba);
        str_title = sprintf('%s, Backoff-Fenstergröße von %d [Slots]',str_figure,number_backoff_window_size);
        str_x = 'Anzahl sendender Stationen';
        str_y = 'Anzahl der empfangenen Bytes';
        pos = find(vector_backoff_total == number_backoff_window_size,1);
        if (~isempty(pos))
            vector_y = matrix_evaluation_global_backoff_bytes_mean(:,pos)';
            counter_handler_figure = counter_handler_figure + 1;
            vector_handler_figure(1,counter_handler_figure) = func_figure_backoff_packet_global(figure_number,vector_no_nodes_max_per_experiment,vector_y,str_title,str_x,str_y);
        end
    end
    
    figure_number = figure_number + 1;
    str_title = sprintf('%s, Diff hw-busy + hw-rx', str_figure);
    str_x = 'Backoff';
    str_y = 'Busy - Rx';
    str_legend_title = sprintf('Anzahl sendender Stationen');
    vector_legend = vector_no_nodes_max_per_experiment;
    matrix_diff_2 = matrix_evaluation_global_phy_hardware_busy_mean - matrix_evaluation_global_phy_hardware_received_mean;   
    counter_handler_figure = counter_handler_figure + 1;
   [vector_handler_figure(1,counter_handler_figure)] = func_figure_backoff_global(figure_number,vector_backoff_total,matrix_diff_2,str_title,str_x,str_y,vector_legend(1,1:1:size(matrix_diff_2,1)),str_legend_title);
    
    figure_number = figure_number + 1;
    str_title = sprintf('%s',str_figure);
    str_x = 'Backoff';
    str_y = '%';
    matrix_res = zeros((size(vector_station_filter,2)+size(vector_station_filter,2)), size(vector_backoff_total,2));
    counter_res = 0;
    cell_legend_txt  = cell(1,(size(vector_station_filter,2)+size(vector_station_filter,2)));
    for i = 1:1:size(vector_station_filter,2)
        counter_res = counter_res + 1;
        pos_node = find(vector_no_nodes_max_per_experiment == vector_station_filter(1,i),1);
        if (~isempty(pos_node))
            matrix_res(counter_res,:) = matrix_evaluation_global_phy_hardware_busy_mean(pos_node,:);
            cell_legend_txt(1,counter_res) = {sprintf('hw-busy (%d)',vector_no_nodes_max_per_experiment(1,pos_node))};
            counter_res = counter_res + 1;
            matrix_res(counter_res,:) = matrix_evaluation_global_phy_hardware_received_mean(pos_node,:);
            cell_legend_txt(1,counter_res) = {sprintf('hw-received (%d)',vector_no_nodes_max_per_experiment(1,pos_node))};
        end
    end
    counter_handler_figure = counter_handler_figure + 1;
   [vector_handler_figure(1,counter_handler_figure)] = func_figure_backoff_global_2(figure_number,vector_backoff_total,matrix_res,str_title,str_x,str_y,cell_legend_txt,str_legend_title);
    backoff_filter = 1;
    figure_number = figure_number + 1;
    str_title = sprintf('%s, Backoff-Fenstergröße = %d',str_figure,vector_backoff_total(1,backoff_filter));
    str_legend = 'Anzahl sendender Stationen';
    str_ylabel = '\bf{RSSI}';
    str_xlabel = '\bf{übertragende Bytes}';
    counter_handler_figure = counter_handler_figure + 1;
   [vector_handler_figure(1,counter_handler_figure)] = func_figure_scatter(figure_number,matrix_packet_ranking_nodes(backoff_filter,:)', matrix_rssi_ranking_nodes(backoff_filter,:)',vector_no_nodes_max_per_experiment(1,1:1:size(matrix_packet_ranking_nodes,2)),str_title,str_xlabel,str_ylabel,str_legend);
end

