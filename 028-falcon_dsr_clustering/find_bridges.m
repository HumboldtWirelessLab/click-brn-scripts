function bridges = find_bridges(filename)
  r=load(filename);
  nodes=size(r,1);

  bridges=zeros(nodes,nodes);

  for i=1:nodes
    for j=(i+1):nodes
      if r(i,j) == 1
        r(i,j) = 0;
        r(j,i) = 0;
        c = is_connected(r);
        if c == 0
          bridges(i,j) = 1;
          bridges(j,i) = 1;
        end
        r(i,j) = 1;
        r(j,i) = 1;
      end
    end
  end

  bridges
end
