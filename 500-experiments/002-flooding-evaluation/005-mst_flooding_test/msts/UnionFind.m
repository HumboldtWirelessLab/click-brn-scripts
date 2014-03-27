classdef UnionFind < handle
    %UnionFind Implementiert eine UnionFind-Datenstruktur mit
    %Pfadkompression und Union-by-Size
    
    properties (Access = private)
        parent
        size
        partitions        
    end
    
    methods
        function obj = UnionFind(n) %erstellt ein UnionFind der Länge n
            obj.parent=1:n;
            obj.size=ones(n,1);
            obj.partitions=n;
        end
        
        function par = getParent(obj,n)
            if (n~=obj.parent(n))
                obj.parent(n)=obj.getParent(obj.parent(n));
            end
            par=obj.parent(n);
        end
        
        function union(obj,a,b)
            a=obj.getParent(a);
            b=obj.getParent(b);
            if a~=b
                if (obj.size(a)>obj.size(b))
                    obj.size(a)=obj.size(a)+obj.size(b);
                    obj.parent(b)=a;
                else
                    obj.size(b)=obj.size(a)+obj.size(b);
                    obj.parent(a)=b; 
                end
                obj.partitions=obj.partitions-1;
            end
        end
        
        function b = connected(obj)
            b=~logical(obj.partitions-1);
        end
        
        function s = getSize(obj,n)
            s=obj.size(obj.getParent(n));
        end
        
    end
    
end

