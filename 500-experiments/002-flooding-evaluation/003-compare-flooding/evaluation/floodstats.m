function floodstats(filename)

data=load(filename);
%size(data)

data=[ data';zeros(1,size(data,1)) ]';
params=unique(data(:,[2 3 4]),'rows')
%size(params)

result=zeros(size(params,1),4);

for r = 1:size(params,1)
    
    p=params(r,:);
    data(find((data(:,2) == p(1)) & (data(:,3) == p(2)) & (data(:,4) == p(3))),size(data,2)) = r;
    p_data=data(find((data(:,2) == p(1)) & (data(:,3) == p(2)) & (data(:,4) == p(3))),:);
    
    %size(p_data)
   
    
    result(r,1)=r;
    result(r,2)=mean(p_data(:,5));
    result(r,3)=mean(p_data(:,7));
    result(r,4)=mean(p_data(:,8));
    
end


boxplot(data(:,5),data(:,size(data,2)));
title('Reachability');
ylabel('Reachability (%)');
xlabel('Flooding');

figure;
boxplot(data(:,7),data(:,size(data,2)));
title('Number of Pkts. sent');
ylabel('No. Pkts. (Sent)');
xlabel('Flooding');

figure;
boxplot(data(:,8),data(:,size(data,2)));
title('Pkts. forward');
ylabel('No. Pkts. (Forward)');
xlabel('Flooding');

packets_per_reach=data(:,7)./data(:,5);
figure;
boxplot(packets_per_reach,data(:,size(data,2)));
title('Pkts. per Reachability %');
ylabel('Pkts/%');
xlabel('Flooding');


A=5;
B=2;

fn=data(:,7)./(data(:,9).*data(:,6))
fn = max(fn, 0.25); %(fn(:)<0.25) = 0.25;
D=data(:,5)/100;

Z=(D.^A)./(fn.^(1/B));
%D=reachability
%fn=#of send pkt / #Knoten
%z=(D^A/((max(fn,0.25))^(1/B))

figure;
boxplot(Z,data(:,size(data,2)));
title('Utility');
ylabel('Utility');
xlabel('Flooding');

end