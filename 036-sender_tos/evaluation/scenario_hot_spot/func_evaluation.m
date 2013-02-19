function func_evaluation(file_directory,file_name,file_directory_save,csv_divide_data,flag_std,figure_save_on,vector_receiver_station_filter,vector_receiver_backoff_filter,vector_sender_backoff_filter,vector_sender_station_filter)
%clear all;
%close all;
%file_directory = 'inrange-2013-01-14';
%file_directory = '20130117_small-result';
%file_directory_save = 'figures';
%file_name = 'inrange.mat';
%file_name = 'two_way_ground_unicast_receiver.mat';
%file_name = 'two_way_ground_broadcast_receiver.mat';
%file_name = 'shadowing_unicast_receiver.mat';
%file_name = 'shadowing_broadcast_receiver.mat';

%file_name = 'two_way_ground_unicast_sender.mat';
%file_name = 'two_way_ground_broadcast_sender.mat';
%file_name = 'shadowing_broadcast_sender.mat';
%file_name = 'shadowing_unicast_sender.mat';
%divide_data_and_csv_write_on = 0; % 0:= off; 1:= on
%evaluate_receiver_on = 1; % 0:= off; 1:= off
%evaluate_sender_on = 1; % 0:= off; 1:= on
%divide_per_packet_size_on = 1; % 0:=off; 1:= on
%flag_std = 0; % see std matlab description, there are two equations
%figures_all = 0; % 0:= off; 1:= on; there are more figures in func_evaluation_receiver_divide_packets that are till now unused
debug_on = 0; % 0:= off; 1:=on
%figure_save_on = 1; % 0:= off, 1:= on
%vector_receiver_station_filter = [2,10];     
%vector_receiver_backoff_filter = [16,32];
%vector_sender_backoff_filter = -1;
%vector_sender_station_filter = -1;

file_txt = sprintf('%s/%s',file_directory,file_name);

number = 1; %NUM
number_of_nodes = 2; %NO_NODES (Total number of sender nodes for this experiment)
packet_size = 3; %PACKETSIZE
backoff_window_size_min = 4;%BACKOFF_Min (this will be currently evaluated)
backoff_window_size_max = 5;%BACKOFF_MAX (TODO:this values are not correct)
seed = 6; %SEED
rate = 7; %RATE
time = 8; %TIME
node = 9; %NODE (information collected from a node)
id = 10; %ID
phy_hardware_busy = 11; %PHY_HWBUSY
phy_hardware_received = 12; %PHY_HWRX
phy_hardware_transmitted = 13; %PHY_HWTX
mac_packet_received = 14; %RXPKT
mac_packet_error_crc = 15; %CRCPKT
mac_packet_error_phy = 16; %PHYPKT
mac_address_source = 17; %ADDR (Number of neighbour nodes, seen from a special node)
rssi_value = 18; %RSSI
rssi_value_standard_deviation = 19; %STDRSSI
rssi_value_min = 20; %MINRSSI
rssi_value_max = 21; %MAXRSSI
packet_counter = 22; %PKTCNT (has to be the last element)
%---------- new params ----------------------------------
receiver_retries = 23; %RXRETRIES Retry-Counter
sender_retries = 24; %TXRETRIES
mac_busy = 25; %MAC_BUSY
mac_rx = 26; %MAC_RX
mac_tx = 27; %MAC-TX
missed_sequence_number = 28; %MISSED_SEQ
channel = 29; %Channel (has to be the last element, when the new params are aggregated)
target = 30; %Target;  0: broadcast 1: unicast
channel_model = 31; %Channelmodel; 0: real (testbed) 1: shadowing 2: twowayground


last_element = channel_model; 
[matrix] = func_testbed_results_read(file_txt,last_element);
[matrix] = func_filter_nodes(matrix,number_of_nodes,mac_address_source);
figure_number = 1;
str_figure_title = '';
file_output = '';
counter_figures = 0;
vector_handler_figure_receiver = 0;
vector_handler_figure_sender = -1;

vector_channel_models = unique(matrix(:,channel_model));
vector_targets_total = unique(matrix(:,target)); % unicast and broadcast       
for i= 1:1:size(vector_channel_models,1)
    for j = 1:1:size(vector_targets_total,1)
        kind_of_channel_model = vector_channel_models(i,1);
        if (kind_of_channel_model == 1)
            str_figure_title = sprintf('Shadowing');
            file_output = 'shadowing';
        elseif (kind_of_channel_model == 2)
            str_figure_title = sprintf('Two Way Ground');
            file_output = 'two_way_ground';
        elseif (kind_of_channel_model == 0)
            str_figure_title = sprintf('Real'); % Testbed
            file_output = 'real';
        end
        kind_of_transfer = vector_targets_total(j,1);
        if (kind_of_transfer == 0)
            str_figure_title = sprintf('%s, Broadcast',str_figure_title);
            file_output = sprintf('%s_broadcast',file_output);
        elseif (kind_of_transfer == 1)
            str_figure_title = sprintf('%s, Unicast',str_figure_title);
            file_output = sprintf('%s_unicast',file_output);
        end
        [matrix_filtered] = func_filter(matrix,channel_model,kind_of_channel_model);
        [matrix_filtered] = func_filter(matrix_filtered,target,kind_of_transfer);
        [matrix_sender,matrix_receiver] = func_filter_sender_receiver(matrix_filtered,node);
        if (csv_divide_data == 1)
            file_data_receiver = sprintf('%s/%s_receiver.mat',file_directory,file_output);
            csvwrite(file_data_receiver,matrix_receiver);
            file_data_sender = sprintf('%s/%s_sender.mat',file_directory,file_output);
            csvwrite(file_data_sender,matrix_sender);
        end
            if (~isempty(matrix_receiver))
                str_figure_title_receiver = sprintf('%s, R',str_figure_title);
                if (debug_on == 1)
                    disp(str_figure_title_receiver)
                    vector_receiver_retries = unique(matrix_receiver(:,receiver_retries));
                    vector_sender_retries = unique(matrix_receiver(:,sender_retries));
                    vector_missed_sequence_number = unique(matrix_receiver(:,missed_sequence_number));
                    disp('receiver retries:')
                    disp(vector_receiver_retries);
                    disp('sender retries:')
                    disp(vector_sender_retries);
                    disp('missed sequence number');
                    disp(vector_missed_sequence_number);
                end
                [figure_number,vector_handler_figure_receiver] = func_evaluation_receiver(matrix_receiver,packet_size,mac_address_source,number_of_nodes,packet_counter,backoff_window_size_min,mac_packet_received,mac_packet_error_crc,mac_packet_error_phy,rssi_value,rssi_value_standard_deviation,phy_hardware_busy,phy_hardware_received,missed_sequence_number,str_figure_title_receiver,figure_number,flag_std,vector_receiver_station_filter,vector_receiver_backoff_filter);
                figure_number = figure_number + 1;
            end
            if (~isempty(matrix_sender))
                str_figure_title_sender = sprintf('%s, S',str_figure_title);
                if (debug_on == 1)
                    disp(str_figure_title_sender)
                    vector_receiver_retries = unique(matrix_sender(:,receiver_retries));
                    vector_sender_retries = unique(matrix_sender(:,sender_retries));
                    vector_missed_sequence_number = unique(matrix_sender(:,missed_sequence_number));
                    disp('receiver retries:')
                    disp(vector_receiver_retries);
                    disp('sender retries:')
                    disp(vector_sender_retries);
                    disp('missed sequence number');
                    disp(vector_missed_sequence_number);
                end
                [figure_number,vector_handler_figure_sender]  = func_evaluation_senders(matrix_sender,node,number_of_nodes,backoff_window_size_min,sender_retries,str_figure_title_sender,figure_number,flag_std,vector_sender_station_filter,vector_sender_backoff_filter);
            end
         if (figure_save_on == 1)
             for fn = 1:1:size(vector_handler_figure_receiver,2)
                 counter_figures = counter_figures + 1;
                 string = num2str(counter_figures);
                 file_na = sprintf('%s/receiver_%s',file_directory_save,string);
                 saveas(vector_handler_figure_receiver(1,fn),file_na,'epsc') 
             end
             if (vector_handler_figure_sender(1,1) ~= -1)
                for fn = 1:1:size(vector_handler_figure_sender,2)
                    counter_figures = counter_figures + 1;
                    string = num2str(counter_figures);
                    file_na = sprintf('%s/sender_%s',file_directory_save,string);
                    saveas(vector_handler_figure_sender(1,fn),file_na,'epsc') 
                end
             end
         end
        figure_number = figure_number + 1;
    end
end



end

