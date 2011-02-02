function eval_txdiv(filename,outtake,prefix_name)
  %filename = '../17/evaluation/macclone_data.mat';
  scrsz = [ 1 1 800 600 ];
  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
  set(gcf,'paperpositionmode','auto');
  set(gca,'fontsize',16);

%layout: nodenumber mode(rx/tx/ack) rate rssi id id seq is_retry is_err retries
%mode: tx: 0 rx: 1 ack: 2
  data=load(filename,'-ASCII');
  nodes=unique(data(:,1));
  id=unique(data(data(:,2)==0,5));
  rx_nodes=nodes(nodes(:) > 0,:);
  
  size(id)
  size(rx_nodes)
  
  psr=zeros(size(id,1),size(rx_nodes,1));
  pcrcr=zeros(size(id,1),size(rx_nodes,1));
  group_psr=zeros(size(id,1),3);          % no_send_packets ; no_received_packets ; psr
%  group_ack_sr=zeros(size(id,1),5);       % no_received_packets ; no_succ_ack ; no_err_ack ; ack_succ_rate ; ack_err_rate
  
  group_size_psr=zeros(size(rx_nodes,1),3); % no_send_packets ; no_received_packets ; psr
  real_rx_node_ack_per=zeros(size(rx_nodes,1),7); % packet_received ack_ok ack_err no_ack ack_ok_r ack_err_r no_ack_r
  
  mean_rssi=zeros(size(rx_nodes,1),1);
  
  for i = 1:size(id,1)
    group_nodes=get_set_bits(id(i));
    
    send_packets=data((data(:,1)==0) & (data(:,5)==id(i)) & (data(:,2)==0),[ 7 4 10 11]); %seq rssi retries time
    received_ok_acks=data((data(:,1)==0) & (data(:,5)==id(i)) & (data(:,2)==2) & (data(:,9)==0),[ 7 4 11 ]); % seq rssi time
    received_err_acks=data((data(:,1)==0) & (data(:,5)==id(i)) & (data(:,2)==2) & (data(:,9)==1),[ 7 4 11 ]); %seq rssi time
    
    received_packets=data((data(:,1) ~= 0) & (data(:,5)==id(i)) & (data(:,2)==1),[ 1 7 4 9 11]);
    
    group_rx = [];
    
    for r = 1:size(rx_nodes,1)
      rx_ok_packets=received_packets((received_packets(:,1) == rx_nodes(r)) & (received_packets(:,4) == 0),:);
      rx_err_packets=received_packets((received_packets(:,1) == rx_nodes(r)) & (received_packets(:,4) == 1),:);
      psr(id(i),rx_nodes(r)) = size(rx_ok_packets,1) / size(send_packets,1);
      pcrcr(id(i),rx_nodes(r)) = size(rx_err_packets,1) / size(send_packets,1);
      
      if ismember(rx_nodes(r),group_nodes)
        group_rx=[ group_rx ; rx_ok_packets(:,[ 1 2 ]) ]; %node and seq_num
      end
    end
    
    if size(group_nodes,1) == 1
        group_nodes
      %received_ok_acks(received_ok_acks(:,2) < 200,2)
      if ~isempty(received_ok_acks(received_ok_acks(:,2) < 200,2))
        mean_rssi(group_nodes(1),1) = mean(received_ok_acks(received_ok_acks(:,2) < 200,2)); %rssi
      else
        mean_rssi(group_nodes(1),1) = 0;
      end
    end
        
    group_size_psr(size(group_nodes,1),1) = group_size_psr(size(group_nodes,1),1) + size(send_packets,1);
    group_size_psr(size(group_nodes,1),2) = group_size_psr(size(group_nodes,1),2) + size(send_packets(send_packets(:,3) == 0 ,:),1);
    group_size_psr(size(group_nodes,1),3) = group_size_psr(size(group_nodes,1),2) / group_size_psr(size(group_nodes,1),1); 
    
    
    group_psr(id(i),1) = size(send_packets,1);
    group_psr(id(i),2) = size(unique(group_rx(:,2)),1);
    group_psr(id(i),3) = group_psr(id(i),2) / group_psr(id(i),1);
    
    seq_numb=send_packets(:,1);
        
    send_and_ack_packets=sortrows(data((data(:,1)==0) & (data(:,5)==id(i)) & ((data(:,2)==0) | (data(:,2)==2)),[ 2 7 4 9 10 11]),6); %mode seq rssi err retries // time
    
    for s = 1:size(seq_numb,1)
      req_rx_nodes=group_rx(group_rx(:,2) == seq_numb(s),1);
      seq_index=find( (send_and_ack_packets(:,2) == seq_numb(s)) & (send_and_ack_packets(:,1) == 0));
      if ( size(seq_index,1)  ~= 1)
          disp('ERROROROROROR');
      end
      
      packet=send_and_ack_packets(seq_index,:);
      if seq_index(1) >= size(send_and_ack_packets,1)
        next_packet=[0 0 0 0 0];  
      else
        next_packet=send_and_ack_packets(seq_index+1,:);
      end
      
      if size(req_rx_nodes,1) > 0                                                                        %packet is received
       if (size(req_rx_nodes,1) == 1) & (ismember(req_rx_nodes,outtake))
         lll=0;
       else

        real_rx_node_ack_per(size(req_rx_nodes,1),1) = real_rx_node_ack_per(size(req_rx_nodes,1),1) + 1;
        
        p_short=packet(:,[1:5]);
        n_short=next_packet(:,[1:5]);
        if next_packet(1,1) == 2                                                                         %received ack
          if next_packet(1,4) == 0                                                                       % no err
            real_rx_node_ack_per(size(req_rx_nodes,1),2) = real_rx_node_ack_per(size(req_rx_nodes,1),2) + 1;
          else
            real_rx_node_ack_per(size(req_rx_nodes,1),3) = real_rx_node_ack_per(size(req_rx_nodes,1),3) + 1;  
          end
        else
          if packet(1,5) == 0 
            disp('ERROR: no retry and no ack');
          end
          real_rx_node_ack_per(size(req_rx_nodes,1),4) = real_rx_node_ack_per(size(req_rx_nodes,1),4) + 1;
        end
       end 
      end
    end
    
  end

  real_rx_node_ack_per(:,5) = real_rx_node_ack_per(:,2) ./ real_rx_node_ack_per(:,1);
  real_rx_node_ack_per(:,6) = real_rx_node_ack_per(:,3) ./ real_rx_node_ack_per(:,1);
  real_rx_node_ack_per(:,7) = real_rx_node_ack_per(:,4) ./ real_rx_node_ack_per(:,1);

  clf;
  scatter([1:size(rx_nodes,1)],real_rx_node_ack_per(:,5));
  grid on;
  title('Packet Success Rate (Acknowledgement)','FontSize',18);
  ylabel('Packet Success Rate','FontSize',18);
  xlabel('No. concurrent transmitter','FontSize',18);
  ylim([0.2 1.0]);
  xlim([0.5 6.5]);
  set(gca,'FontSize',14);
  set(gca,'XTickLabel',['1';'2';'3';'4';'5';'6']);
  
  print('-deps2c', strcat( prefix_name, 'ack_per.eps'));

  clf;
  scatter([1:size(rx_nodes,1)],mean_rssi(:,1));
  grid on;
  title('RSSI of acknowledgements (Single nodes)','FontSize',18);
  ylabel('RSSI','FontSize',18);
  xlabel('Node','FontSize',18);
  xlim([0.5 6.5]);
  set(gca,'FontSize',14);
  set(gca,'XTickLabel',['1';'2';'3';'4';'5';'6']);
%  set(gca,'XTickLabel',[' ';'1';' ';'2';' ';'3';' ';'4';' ';'5';' ';'6']);

  print('-deps2c', strcat( prefix_name, 'rssi.eps'));

  clf;
  scatter([1:size(rx_nodes,1)],group_size_psr(:,3));
  grid on;
  title('Packet Success Rate (Data + Acknowledgement)','FontSize',18);
  ylabel('Packet Success Rate','FontSize',18);
  xlabel('No. nodes per group','FontSize',18);
  ylim([0.2 1.0]);
  xlim([0.5 6.5]);
  set(gca,'FontSize',14);
  set(gca,'XTickLabel',['1';'2';'3';'4';'5';'6']);
  print('-deps2c', strcat( prefix_name, 'psr.eps'));

  clf;
  scatter([1:size(rx_nodes,1)],real_rx_node_ack_per(:,6));
  grid on;
  title('Fraction of CRC errors (Acknowledgment)','FontSize',18);
  ylabel('CRC error','FontSize',18);
  xlabel('No. nodes per group','FontSize',18);
  xlim([0.5 6.5]);
  set(gca,'FontSize',14);
  set(gca,'XTickLabel',['1';'2';'3';'4';'5';'6']);
  print('-deps2c', strcat( prefix_name, 'crc.eps'));

  clf;
  
  X_PLOT_SIZE=2;
  Y_PLOT_SIZE=3;

  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
  scatter([1:size(rx_nodes,1)],real_rx_node_ack_per(:,5));
  grid on;
  title('Fraction ok ack');

  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,2);
  scatter([1:size(rx_nodes,1)],real_rx_node_ack_per(:,6));
  grid on;
  title('Fraction crc_err_ack');

  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,3);
  scatter([1:size(rx_nodes,1)],real_rx_node_ack_per(:,7));
  grid on;
  title('Fraction no ack received');

  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,4);
  scatter([1:size(rx_nodes,1)],mean_rssi(:,1));
  grid on;
  title('RSSI');

  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,5);
  scatter([1:size(rx_nodes,1)],group_size_psr(:,3));
  grid on;
  title('PSR');

end
