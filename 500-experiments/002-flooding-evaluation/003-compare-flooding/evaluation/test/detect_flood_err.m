LASTNODE=1;
NODE=2;
SRC=3;
SIZE=4;
COUNT=10;

ID=11;
FWD_COUNT=12;
SENT=13;
FORWED=14;
RESP=15;

FOREIGN_RESP=16;
RX_ACK=17;
RX_COUNT=18;
FWD_DONE=19;
FWD_SUCC=20;

FIN_RESP=21;
TIME=22;

a=load('floodingforwardstats.mat','-ASCII');

nodes=sort(unique(a(:,NODE)));
pkts=unique(a(:,COUNT));

disp('--------------------- S T A R T ------------------------');

for n=1:size(nodes)

  node = nodes(n);
  ids = unique(a(find(a(:,NODE) == node),ID));    %welche ids hat der Knoten

  if ( size(ids,1) ~= pkts )
    z=zeros(pkts,1);
    z(ids)=1;
    missed_ids=find(z(:) == 0);
    for mi = size(missed_ids,1)
      node
      missed_id = missed_ids(mi)-1
      %resp = a(find((a(:,11)==missed_ids(mi)) & (a(:,15)==1)),2)
      %ack = a(find((a(:,11)==missed_ids(mi)) & (a(:,1)==node) & ((a(:,17)~=0) | a(:,18)~=0)),:)
      
      %disp('This nodes have the node as lastnode with this id:');
      %disp('     NODE       SENT      RESP  FOREIGN_RESP  RX_ACK      RX_COUNT     TIME    LASTNODE      FIN_RESP');
      
      has_as_last_node = a(find((a(:,ID)==missed_id) & (a(:,LASTNODE)==node)),[NODE SENT RESP FOREIGN_RESP RX_ACK RX_COUNT TIME LASTNODE FIN_RESP])
      
      % reverse
      %for mi_rev = 1:size(has_as_last_node,1)
      %    disp('More information about this nodes having the node as lastnode with this id:');
      %    disp('       LASTNODE         NODE        SENT       RESP     FOREIGN_RESP      RX_ACK    RX_COUNT    TIME');
      %    node_rev = has_as_last_node(mi_rev,1);
      %    has_as_last_node_rev = a((a(:,ID)==missed_ids(mi)) & (a(:,NODE)==node_rev),[LASTNODE NODE SENT RESP FOREIGN_RESP RX_ACK RX_COUNT TIME])       
      %end
      %break;
    end
    %break;
  end

end
