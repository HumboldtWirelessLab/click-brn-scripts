function [ ] = dist2pdr(pos_path, output_path)

    a=sortrows(load(pos_path),1);
    
    dist=zeros(size(a,1),size(a,1));
    
    for i=1:size(a,1)
      for j=i:size(a,1)
        if ( i ~= j )
          dist(i,j) = round(sqrt((a(i,2)-a(j,2))^2 + (a(i,3)-a(j,3))^2));
          dist(j,i) = dist(i,j); 
        end
      end
    end
    dist
    %size(dist)
    %disp(output_path)
    csvwrite(output_path, dist);
    
end
