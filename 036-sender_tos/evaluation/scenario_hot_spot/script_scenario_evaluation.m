clear all;
close all;
%file_txt = 'inrange_2.mat';%old
%file_txt = 'inrange.mat';%new
file_txt =  '2012-01-05-simulation-bcast/inrange.mat';

number = 1; %NUM
number_of_nodes = 2; %NO_NODES (Total number of neighbour nodes)
packet_size = 3; %PACKETSIZE
backoff_window_size_min = 4;%BACKOFF_Min (this will be currently evaluated)
backoff_window_size_max = 5;%BACKOFF_MAX (TODO:this values are not correct)
seed = 6; %SEED
rate = 7; %RATE
time = 8; %TIME
node = 9; %NODE (information from a special node)
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

    
 [matrix] = func_testbed_results_read(file_txt,channel);
 [matrix_sender,matrix_receiver] = func_filter_sender_receicer(matrix,node);
 func_evaluation_receiver(matrix_receiver,number,packet_size,mac_address_source,number_of_nodes,packet_counter,backoff_window_size_min,rssi_value);


