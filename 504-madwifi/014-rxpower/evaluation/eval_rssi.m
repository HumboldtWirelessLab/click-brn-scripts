function [rssi] = eval_rssi(filename)

r=load(filename,'-ASCII');
rssi=r(:,1);
rssi(rssi>100)=[];

end
