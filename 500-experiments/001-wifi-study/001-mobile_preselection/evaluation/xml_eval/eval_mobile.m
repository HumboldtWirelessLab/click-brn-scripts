function eval_mobile(csfilename, gpsfilename)

  STEPSIZE=0.0002;
  %csdata=load(csfilename,'-ASCII');
  gpsdata=load(gpsfilename,'-ASCII');

  lat=gpsdata(:,3);
  long=gpsdata(:,4);
  
  lat(lat==0)=[];
  long(long==0)=[];
  
  minlat=floor(min(lat)/STEPSIZE)*STEPSIZE
  maxlat=ceil(max(lat)/STEPSIZE)*STEPSIZE
  
  latsteps=((maxlat-minlat)/STEPSIZE) + 1;
  
  minlong=floor(min(long)/STEPSIZE)*STEPSIZE
  maxlong=ceil(max(long)/STEPSIZE)*STEPSIZE
  
  longsteps=(maxlong-minlong)/STEPSIZE + 1;
  
  
  
  
  
  times=gpsdata(:,2);
  
  ac_lat = maxlat;
  ac_long = minlong;
  
  time_data=zeros(latsteps,longsteps);
  
  for slat = 1:latsteps
    next_ac_lat = ac_lat-STEPSIZE;
    
    lat_data=gpsdata(find((gpsdata(:,3) < ac_lat) & (gpsdata(:,3) >= next_ac_lat)),:);
    
    if ~isempty(lat_data)
      
      %size(lat_data)
      ac_long = minlong;
      
      for slong = 1:longsteps
        next_ac_long = ac_long+STEPSIZE;
        
        latlongdata=lat_data(find((lat_data(:,4) >= ac_long) & (lat_data(:,4) < next_ac_long)),:);

        if ~isempty(latlongdata)
          %size(latlongdata)
          time_data(slat,slong)=mean(latlongdata(:,2))-min(times);          
        end
        
        ac_long = next_ac_long;
        
      end
    end
    
    ac_lat = next_ac_lat;
  end
  
  %time_data
  scrsz = [ 1 1 500 500 ];
  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
  set(gcf,'paperpositionmode','auto');
  set(gca,'fontsize',16);

  X_PLOT_SIZE=1;
  Y_PLOT_SIZE=1;
  
  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
  
  [X,Y]=meshgrid(latsteps,longsteps);
  Z=time_data;
  X
  Y
  size(Z)
  
  surf([1:X],[1:Y],Z');

  
end
