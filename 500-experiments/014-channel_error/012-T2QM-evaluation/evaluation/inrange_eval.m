NUM=1;
NO_NODES=2;
PACKETSIZE=3;
BACKOFF_MAX=4;
BACKOFF=5;
SEED=6;
RATE=7;
TIME=8;
NODE=9;
ID=10;
PHY_HWBUSY=11;
PHY_HWRX=12;
PHY_HWTX=13;
RXPKT=14;
CRCPKT=15;
PHYPKT=16;
ADDR=17;
RSSI=18;
STDRSSI=19;
MINRSSI=20;
MAXRSSI=21;
PKTCNT=22;
RXRETRIES=23;
TXRETRIES=24;
MAC_BUSY=25;
MAC_RX=26;
MAX_TX=27;
MISSED_SEQ=28;
CHANNEL=29;
TARGET=30;
CHANNELMODEL=31;
TQM=32;

cm_string={'real';'shadowing';'tworay'};
target_string={'bcast';'unicast'};
tqm_string={ 'off';'on'};

print=1;
a_load=load('inrange_plain_new_bigger_queue.mat','-ASCII');
a=a_load(find(a_load(:,NODE) == 1),:); %reciever only

all_ps=unique(a(:,PACKETSIZE))
cmodel=unique(a(:,CHANNELMODEL))
all_targets=unique(a(:,TARGET))

tqmmodes=unique(a(:,TQM))
no_nodes=unique(a(:,NO_NODES))

jfn_matrix = [];

for ps_i = 1:size(all_ps,1)
  for cm_i = 1:size(cmodel,1)
    for tar_i = 1:size(all_targets,1)

      result=zeros(size(no_nodes,1),13);

      data=a(find((a(:,PACKETSIZE) == all_ps(ps_i)) & (a(:,CHANNELMODEL) == cmodel(cm_i)) & (a(:,TARGET) == all_targets(tar_i))), :);
      size(data);
      
      jfn = [];
      
      for tqm_i = 1:size(tqmmodes,1)
        for non_i = 1:size(no_nodes,1)
          nodes_data=data(find((data(:,TQM) == tqmmodes(tqm_i)) & (data(:,NO_NODES) == no_nodes(non_i))), :);
          no_nodes(non_i);
          
          measpoint=unique(nodes_data(:,ID));
          %size(measpoint)
          
          sum_tp = 0;
          
          mp_r_pktc = [];
          mp_r_hw_busy = [];
          mp_r_hw_rx = [];

          for m_i = 1:size(measpoint,1)
              mn_data=nodes_data(find(nodes_data(:,ID) == measpoint(m_i)), :);
              size(mn_data);
              mp_r_pktc = [ mp_r_pktc (8*1500*sum(mn_data(:,PKTCNT)))/1024 ];
              mp_r_hw_busy = [ mp_r_hw_busy mean(mn_data(:,PHY_HWBUSY)) ];
              mp_r_hw_rx = [ mp_r_hw_rx mean(mn_data(:,PHY_HWRX)) ];
          end
          
          if ( no_nodes(non_i) == 25 )
            m_nodes=unique(nodes_data(:,ADDR));
            m_tps = [];

            for nm = 1:size(m_nodes,1)
              ac_n = m_nodes(nm);
              m_tps = [ m_tps mean(nodes_data(find(nodes_data(:,ADDR) == ac_n),PKTCNT)) ];
            end
            
            jfn = [ jfn tqmmodes(tqm_i) ((sum(m_tps)*sum(m_tps)) / (no_nodes(non_i) * sum(m_tps.*m_tps))) ];
          end
          
          result(non_i,1) = no_nodes(non_i);
          result(non_i,tqmmodes(tqm_i)+2) = mean(mp_r_pktc);
          result(non_i,tqmmodes(tqm_i)+4) = std(mp_r_pktc) / sqrt(size(mp_r_pktc,1));
          result(non_i,tqmmodes(tqm_i)+6) = mean(mp_r_hw_busy);
          result(non_i,tqmmodes(tqm_i)+8) = mean(mp_r_hw_rx);
          result(non_i,tqmmodes(tqm_i)+10) = std(mp_r_hw_busy) / sqrt(size(mp_r_hw_busy,1));
          result(non_i,tqmmodes(tqm_i)+12) = std(mp_r_hw_rx) / sqrt(size(mp_r_hw_rx,1));
        end
      end    
      
      target_string(all_targets(tar_i)+1);
      cm_string(cmodel(cm_i)+1);
      jfn;
      jfn_matrix = [ jfn_matrix ; [ all_ps(ps_i) cmodel(cm_i) all_targets(tar_i) jfn ] ];
      
      %result      
      
      h1=figure;
      plot(result(:,1),result(:,2),'b*-');
      hold on;
      plot(result(:,1),result(:,3),'ro-');
      hold on;
      errorbar(result(:,1),result(:,2),result(:,4),'b');
      hold on;
      errorbar(result(:,1),result(:,3),result(:,5),'r');
      %title(strcat('PKTCNT Target: ', num2str(all_targets(tar_i)), ' Channelmodel: ', num2str(cmodel(cm_i))));
      xlim([1 26]);
      xlabel('#Sender');
      ylim([0 1000]);
      ylabel('Mittlerer Durchsatz (kbits/s)');
      legend('802.11 (Std.)','TQM','location','Best');
      grid on;
      
      if ( print == 1 )
        fname=strcat('tp_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'.png');
        saveas(h1, fname{1} ,'png');      
        fname=strcat('tp_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'.eps');
        saveas(h1, fname{1}, 'eps');
      end
      
      
      h2=figure;
      plot(result(:,1),result(:,6),'b*-');
      hold on;
      plot(result(:,1),result(:,8),'ro-');
      %title(strcat('TQM:0 Target: ', num2str(all_targets(tar_i)), ' Channelmodel: ', num2str(cmodel(cm_i))));
      xlim([1 26]);
      xlabel('#Sender');
      ylim([0 100]);
      ylabel('Kanalbelegung (in Prozent)');
      legend('Busy','RX','location','Best');
      grid on;

      if ( print == 1 )
        fname=strcat('tqm_off_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'.png');
        saveas(h2, fname{1},'png');      
        fname=strcat('tqm_off_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'.eps');
        saveas(h2,fname{1},'eps');      
      end

      h3=figure;
      plot(result(:,1),result(:,7),'b*-');
      hold on;
      plot(result(:,1),result(:,9),'ro-');
      %title(strcat('TQM:1 Target: ', target_string(all_targets(tar_i)+1), ' Channelmodel: ', cm_string(cmodel(cm_i)+1)));
      xlim([1 26]);
      xlabel('#Sender');
      ylim([0 100]);
      ylabel('Kanalbelegung (in Prozent)');
      legend('Busy','RX','location','Best');
      grid on;

      if ( print == 1 )
        fname=strcat('tqm_on_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'.png');
        saveas(h3, fname{1},'png');
        fname=strcat('tqm_on_target_', target_string(all_targets(tar_i)+1) , '_channelmodel_', cm_string(cmodel(cm_i)+1),'.eps');   
        saveas(h3, fname{1},'eps');      
      end

    end
  end  
  
  num2str(jfn_matrix)
end

