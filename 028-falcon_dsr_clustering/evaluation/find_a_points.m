function ap = find_a_points(r)
  nodes=size(r,1);

  ap=zeros(nodes,1);

  for i=1:nodes
    r_ns=r(1,:);
    r_ow=r(:,1);
    r(i,:)=zeros(1,nodes);
    r(:,i)=zeros(nodes,1);
    c = is_connected(r);
    if c == 0
      ap(i) = 1;
    end
    r(1,:)=r_ns;
    r(:,1)=r_ow;
  end

  ap
end
