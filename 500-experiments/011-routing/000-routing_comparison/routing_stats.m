function routing_stats()
 a=load('result.dat');
 protos=unique(a(:,2));
 
 bytes_cnt=zeros(max(protos),1);
 packet_cnt=zeros(max(protos),1);
 rtt_cnt=zeros(max(protos),1);
 hop_cnt=zeros(max(protos),1);
 
 for p=1:size(protos,1)
 
    bytes_p=a(find((a(:,2)==protos(p)) & (a(:,1)==1)),3);
    packets_p=a(find((a(:,2)==protos(p)) & (a(:,1)==2)),3);
    hops_p=a(find((a(:,2)==protos(p)) & (a(:,1)==1)),7);
    rtt_p=a(find((a(:,2)==protos(p)) & (a(:,1)==2)),8);
    
    bytes_cnt(p)=mean(bytes_p);
    packet_cnt(p)=mean(packets_p);
    hop_cnt(p)=mean(hops_p);
    rtt_cnt(p)=mean(rtt_p);
    
 
 end
 
 bytes_cnt
 packet_cnt
 
 clf;
 scatter(protos,bytes_cnt)
 title('BYTES');
 ylabel('no. bytes');
 ylim([0 max(bytes_cnt) * 1.1]);
 xlim([0 max(protos) + 1]);
 
 figure
 scatter(protos,packet_cnt)
 title('PACKETS');
 ylabel('no. packets');
 ylim([0 max(packet_cnt) * 1.1]) 
 xlim([0 max(protos) + 1]);
 figure
 scatter(protos,hop_cnt)
 title('HOPS');
 ylabel('no. hops');
 ylim([0 max(hop_cnt) * 1.1]) 
 xlim([0 max(protos) + 1]);
 figure
 scatter(protos,rtt_cnt)
 title('RTT');
 ylabel('ms'); 
 ylim([0 max(rtt_cnt) * 1.1]) 
 xlim([0 max(protos) + 1]);
end
