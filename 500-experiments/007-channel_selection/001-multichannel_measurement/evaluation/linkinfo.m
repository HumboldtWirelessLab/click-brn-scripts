function [ output_args ] = linkinfo(a)
%LINKINFO Summary of this function goes here
%   Detailed explanation goes here

CHANNEL=1;
TIME=2;
BITRATE=3;
SNR=4;
NOISE=5;
SRC=6;
DST=7;
SEQ=8;

nodes=unique(a(:,DST));
channels=unique(a(:,CHANNEL));
rates=unique(a(:,BITRATE));

min_seq=min(a(:,SEQ))
max_seq=max(a(:,SEQ))

%size(nodes)
%nodes

%size(channels)
%channels

size(rates)
rates

channel_pdr=ones(size(channels,1),max(nodes)*max(nodes))*nan;
links=zeros(max(nodes),max(nodes));
channel_links=zeros(size(channels,1),max(nodes)*max(nodes))*nan;

%get values from click-file
INTERVAL=100;
DURATION=120000;
NO_PKTS=DURATION/INTERVAL
NO_PKTS_PER_RATE=NO_PKTS/size(rates,1)

rates=[ 1 ];

min_rate=sort(rates);
min_rate=min_rate(1);

for c=1:size(channels,1)

    cdat=a(a(:,CHANNEL)==channels(c),:);
   
    for r=1:size(rates,1)
         rdat=cdat(cdat(:,BITRATE)==rates(r),:); 

         for n=1:size(nodes,1)
       
             ndat=rdat(rdat(:,DST)==nodes(n),:);
             
             sources=unique(ndat(:,SRC));

             for s=1:size(sources,1)
                 sdat=ndat(ndat(:,SRC)==sources(s),SEQ);
                 channel_pdr(c,(nodes(n)-1)*max(nodes)+sources(s))=size(sdat,1);
                 links(nodes(n),sources(s))=size(sdat,1);
                 if ( rates(r) == min_rate )
                     channel_links(c,nodes(n),sources(s))=size(sdat,1);
                 end
                     
             end
         end
                 
    end
    
end

channel_pdr = channel_pdr/max(max(channel_pdr)); %/NO_PKTS_PER_RATE;

links = links/max(max(links));
valid_links = links(links > 0.2);

channel_links = channel_links/max(max(channel_links));

% --------------- PLOT -------------------------

%channel_pdr = [ channel_pdr channel_pdr];
boxplot(channel_pdr')

figure;
hist(valid_links)

end

