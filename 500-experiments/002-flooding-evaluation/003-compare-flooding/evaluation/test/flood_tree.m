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
FWD_SUCC=20;

FIN_RESP=21;

TIME=22;

if ( ~exist('a') )
  a=load('floodingforwardstats.mat','-ASCII');
end

nodes=sort(unique(a(:,NODE)));
pkts=unique(a(:,COUNT))
ids=unique(a(:,ID))

for n=1:size(ids,1)

  id = ids(n)

  %hole resp-info fuer id
  resp_node_info=a((a(:,ID) == id) & (a(:,RESP)==1),:);

  %histogram: wieviele Knoten waren fuer Knoten 1 bis #nodes verantwortlich (angabe fuer jeden einzelnen Knoten)
  hresp = histc(resp_node_info(:,LASTNODE),nodes);
  hresp'

end
