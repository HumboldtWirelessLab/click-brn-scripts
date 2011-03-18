function eval_mobile(filename)

  STEPSIZE=0.0001;
  data=load(filename,'-ASCII');

  lat=data(:,3);
  long=data(:,4);
  
  lat(lat==0)=[];
  long(long==0)=[];
  
  minlat=floor(min(lat)/STEPSIZE)*STEPSIZE
  maxlat=ceil(max(lat)/STEPSIZE)*STEPSIZE
  
  latsteps=((maxlat-minlat)/STEPSIZE) + 1;
  
  minlong=floor(min(long)/STEPSIZE)*STEPSIZE
  maxlong=ceil(max(long)/STEPSIZE)*STEPSIZE
  
  longsteps=(maxlong-minlong)/STEPSIZE + 1;
  
  
  times=data(:,2);
  
  ac_lat = maxlat;
  ac_long = minlong;
  
  time_data=zeros(latsteps,longsteps);
  hw_busy=zeros(latsteps,longsteps);
  mac_busy=zeros(latsteps,longsteps);
  mac_crc=zeros(latsteps,longsteps);
  
  for slat = 1:latsteps
    next_ac_lat = ac_lat-STEPSIZE;
    
    lat_data=data(find((data(:,3) < ac_lat) & (data(:,3) >= next_ac_lat)),:);
    
    if ~isempty(lat_data)
      
      %size(lat_data)
      ac_long = minlong;
      
      for slong = 1:longsteps
        next_ac_long = ac_long+STEPSIZE;
        
        latlongdata=lat_data(find((lat_data(:,4) >= ac_long) & (lat_data(:,4) < next_ac_long)),:);

        if ~isempty(latlongdata)
          %size(latlongdata)
          time_data(slat,slong)=mean(latlongdata(:,2))-min(times);          
          
          hw_busy(slat,slong)=mean(latlongdata(find(latlongdata(:,23) == 0),16));  %MAC=0 is mainstats 
          mac_busy(slat,slong)=mean(latlongdata(find(latlongdata(:,23) == 0),14)); %MAC=0 is mainstats 
          crc_pkt=latlongdata(find(latlongdata(:,23) == 0),12);
          all_pkt=max(1,latlongdata(find(latlongdata(:,23) == 0),10));
          size(crc_pkt)
          size(all_pkt)
          mac_crc(slat,slong)=mean(crc_pkt./all_pkt);                               %MAC=0 is mainstats 
          
        end
        
        ac_long = next_ac_long;
        
      end
    end
    
    ac_lat = next_ac_lat;
  end
  
  %time_data
  X_PLOT_SIZE=1;
  Y_PLOT_SIZE=1;
  scrsz = [ 1 1 500 500 ];

  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
  set(gcf,'paperpositionmode','auto');
  set(gca,'fontsize',16);
  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
  
  [X,Y]=meshgrid(latsteps,longsteps);
  surf([1:X],[1:Y],mac_busy');
  xlabel('Latitude(N-S)');
  ylabel('Longitude(O-W)');
  zlabel('Fraction (%)');
  title('MAC busy');
  
  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
  
  [X,Y]=meshgrid(latsteps,longsteps);
  surf([1:X],[1:Y],hw_busy');
  xlabel('Latitude(N-S)');
  ylabel('Longitude(O-W)');
  zlabel('Fraction (%)');
  title('NIC busy');

  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
  
  [X,Y]=meshgrid(latsteps,longsteps);
  surf([1:X],[1:Y],(hw_busy-mac_busy)');
  xlabel('Latitude(N-S)');
  ylabel('Longitude(O-W)');
  zlabel('Fraction (%)');
  title('NIC-MAC busy');

  figure('Visible', 'on','Position',[1 scrsz(4) scrsz(3) scrsz(4)])
  subplot(Y_PLOT_SIZE,X_PLOT_SIZE,1);
  
  [X,Y]=meshgrid(latsteps,longsteps);
  surf([1:X],[1:Y],mac_crc');
  xlabel('Latitude(N-S)');
  ylabel('Longitude(O-W)');
  zlabel('Fraction (crc errors)');
  title('CRC-Error');

end
