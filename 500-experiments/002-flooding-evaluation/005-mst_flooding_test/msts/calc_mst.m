function [ ] = calc_mst( pdr_path, output_path, mode )
%CALC_MST Berechnet den minimalen Spannbaum eines Netzwerkes und gibt ihn
%als Kreise aus
%   pdr_path - Dateipfad der PDR
%   output_path - Dateipfad der Ausgabedatei
%   mode - Genutzter Modus zum erhalten eines ungerichteten Graphen (0 - max,
%   1 - min, 2 - mean)

    H=load(pdr_path);
    n=length(H);
    
    erg=-ones(n-1,3);
    erg_count=1;
    
    comps=UnionFind(n);
    
    edges=-ones(n*n,3);
    count=1;
    
    for i=1:n
        for k=1:i-1
            if mode==0
                val=max(H(i,k),H(k,i));
            end
            if mode==1
                val=min(H(i,k),H(k,i));
            end
            if mode==2
                val=(H(i,k)+H(k,i))/2;
            end
            if val>0
                edges(count,1)=val;
                edges(count,2)=i;
                edges(count,3)=k;
                count=count+1;
            end
        end
    end
    
    edges=edges(edges(:,1)~=-1,:);
    [~, IX]=sort(edges(:,1),'descend');
    edges=edges(IX,:);
    
    r=1;
    while ~comps.connected()
       akt=edges(r,:);
       a=comps.getParent(akt(2));
       b=comps.getParent(akt(3));
       if a~=b
          comps.union(akt(2),akt(3));
          erg(erg_count,1)=akt(2);
          erg(erg_count,2)=akt(3);
          erg_count=erg_count+1;
       end
       r=r+1;
    end
    
    %disp(erg);
    fid = fopen(output_path, 'wt');
    for i=1:erg_count-1
        fprintf(fid, '%d ', erg(i,:));
        fprintf(fid, '\n');
    end
    fclose(fid);
end

