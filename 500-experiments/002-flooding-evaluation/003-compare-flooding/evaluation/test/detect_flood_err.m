LASTNODE=1;
NODE=2;
SRC=3;

SIZE=4;
COUNT=10;

ID=11;
SENT=13;
RESP=15;

FOREIGN_RESP=16;
RX_ACK=17;
RX_COUNT=18;

FWD_DONE=19;
FWD_SUC=20;

FIN_RESP=21;

TIME=22;

if ( ~exist('a') )
  a=load('floodingforwardstats.mat','-ASCII');
end

nodes=unique(a(:,NODE));
pkts=unique(a(:,COUNT))

for n=1:size(nodes)

  node = nodes(n);
  ids = unique(a(find(a(:,NODE) == node),ID));    %welche id hat der Knoten

  if ( size(ids,1) ~= pkts )
    z=zeros(pkts,1);
    z(ids)=1;
    missed_ids=find(z(:) == 0);
    for mi = 1:size(missed_ids,1)
      node
      missed_id = missed_ids(mi)
      %resp = a(find((a(:,11)==missed_ids(mi)) & (a(:,15)==1)),2)
      %ack = a(find((a(:,11)==missed_ids(mi)) & (a(:,1)==node) & ((a(:,17)~=0) | a(:,18)~=0)),:)
      %node having missed node as last node for missed id
      has_as_last_node = a(find((a(:,11)==missed_ids(mi)) & (a(:,LASTNODE)==node)),[NODE SENT RESP FOREIGN_RESP RX_ACK RX_COUNT TIME FIN_RESP])
      %node having missed node as last node for missed id and are resp for node
      has_as_last_node_w_resp = a(find((a(:,11)==missed_ids(mi)) & (a(:,LASTNODE)==node) & (a(:,RESP)==1)),[NODE LASTNODE SENT RESP FOREIGN_RESP RX_ACK RX_COUNT TIME FIN_RESP FWD_DONE FWD_SUCC])
      %node having missed node as last node for missed id and saw a foreign resp for the node
      has_as_last_node_w_forresp = a(find((a(:,11)==missed_ids(mi)) & (a(:,LASTNODE)==node) & (a(:,FOREIGN_RESP)==1)),[NODE SENT RESP FOREIGN_RESP RX_ACK RX_COUNT TIME FIN_RESP])

      % reverse
      for mi_rev = 1:size(has_as_last_node_w_resp,1)
          node_rev = has_as_last_node_w_resp(mi_rev,1)
          has_as_last_node_rev = a(find((a(:,11)==missed_ids(mi)) & (a(:,NODE)==node_rev)),[LASTNODE NODE SENT RESP FOREIGN_RESP RX_ACK RX_COUNT TIME])
      end
    end
  end

end

resp = a(a(:,RESP) == 1, [SRC ID NODE LASTNODE]);
size(resp)
ids = unique(a(:,ID));

size_resp_id = zeros(max(ids),1);

for i=1:size(ids,1)
    resp_id = resp(resp(:,2) == ids(i),:);
    size_resp_id(i) = size(resp_id,1);
end

size_resp_id

%hist(size_resp_id); % soviele balken wie ids

bar([1:max(ids)],size_resp_id)

%fuer id == 1
size_resp_nodes = zeros(size(nodes,1),1);

resp_id = resp(resp(:,2) == 1,:);
for n = 1:size(nodes,1)
    size_resp_nodes(n)=size(resp_id(4) == nodes(n),1);
end

hist(size_resp_nodes)