function [ output_args ] = channelload( a )
%CHANNELLOAD Summary of this function goes here
%   Detailed explanation goes here
NODE=1;
CHANNEL=2;
NUM=3;
ID=5;
TIME=6;

HWBUSY=7;
HWRX=8;
HWTX=9;
 
MEAN=1;
MAX=2;
MIN=3;

%a = load(file,'-ASCII');
%size(a)

channels=unique(a(:,CHANNEL));
nums=unique(a(:,NUM));
%size(nums)

%repetitions
rep_cnt=size(nums,1)/size(channels,1);

nodes=unique(a(:,NODE));

times=unique(a(:,TIME));
%size(times)

ids=unique(a(:,ID));
%size(ids)

load_per_channel = zeros(size(channels,1),3);
waste_per_channel = zeros(size(channels,1),3);
load_per_channel_box = zeros(size(channels,1),rep_cnt*size(nodes,1));

%load per channel and node
load_per_channel_node = zeros(size(channels,1),size(nodes,1));

%load per channel and time
load_per_channel_time = zeros(size(channels,1),rep_cnt);

data = a(a(:,ID)~=0,:);

for c=1:size(channels,1)
    channel = channels(c);
    
    cdat = data(data(:,CHANNEL)==channel,:);
        
    load_per_channel(c,MEAN) = mean(cdat(:,HWBUSY));
    load_per_channel(c,MAX) = max(cdat(:,HWBUSY));
    load_per_channel(c,MIN) = min(cdat(:,HWBUSY));

    waste_per_channel(c,MEAN) = mean(cdat(:,HWBUSY)-cdat(:,HWRX));
    waste_per_channel(c,MAX) = max(cdat(:,HWBUSY)-cdat(:,HWRX));
    waste_per_channel(c,MIN) = min(cdat(:,HWBUSY)-cdat(:,HWRX));
    

    for n=1:size(nodes,1)
        ndat = cdat(cdat(:,NODE) == nodes(n),:);
        load_per_channel_node(c,n) = mean(ndat(:,HWBUSY));
    end
    
    cnums=unique(cdat(:,NUM));
    %size(cnums)
    
    for t=1:size(cnums,1)
        tdat = cdat(cdat(:,NUM) == cnums(t),:);
        load_per_channel_time(c,t) = mean(tdat(:,HWBUSY));
    end
    
end

plot(channels,load_per_channel(:,MEAN),'b');
hold on;
plot(channels,load_per_channel(:,MAX),'r');
hold on;
plot(channels,load_per_channel(:,MIN),'g');

figure;
plot(channels,waste_per_channel(:,MEAN),'b');
hold on;
plot(channels,waste_per_channel(:,MAX),'r');
hold on;
plot(channels,waste_per_channel(:,MIN),'g');

figure;
load_per_channel_node = sort(load_per_channel_node,2);
[X,Y]=meshgrid(nodes,channels);
surf(X,Y,load_per_channel_node);
view(2);

figure;
[X,Y]=meshgrid([1:rep_cnt],channels);
surf(X,Y,load_per_channel_time);
view(2);

end

