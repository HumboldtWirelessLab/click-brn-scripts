function a = fix_time(name)

 SRC=3;
 DST=4;
 STATE=5;
 OK=1;
 MASTER=1;
 TIME=1;
 SEQ=13;

 a=load(name);
 nodes=unique(a(:,3));

 %sync node with node 1
 for n=2:size(nodes,1)
  %get ref node

  ref_node=n+1;

  if ref_node > size(nodes,1)
    ref_node=n-1;
  end

  ref_to_master=a(find((a(:,SRC) == nodes(ref_node)) & (a(:,DST) == nodes(MASTER)) & (a(:,STATE) == OK)),[1 13]);
  ref_to_node=a(find((a(:,SRC) == nodes(ref_node)) & (a(:,DST) == nodes(n)) & (a(:,STATE) == OK)),[1 13]);

  %reduce considered packet to avoid colisions
  ref_to_master = ref_to_master([1:100],:);
  ref_to_node = ref_to_node([1:100],:);

  common_packet=intersect(ref_to_master(:,2), ref_to_node(:,2));
  time_diff_vector=zeros(size(common_packet,1),1);
  for p=1:size(common_packet,1)
    time_diff_vector(p) = min(ref_to_master(find(ref_to_master(:,2) == common_packet(p)),1)) - min(ref_to_node(find(ref_to_node(:,2) == common_packet(p)),1));
  end
  time_diff=min(time_diff_vector);

  a(find(a(:,DST) == nodes(n)),1) = a(find(a(:,DST) == nodes(n)),1) + time_diff;
 end

 min_time=min(a(:,TIME));

 a(:,TIME) = a(:,TIME) - min_time;

 %a(:,TIME)
 %min(a(:,TIME))
 %max(a(:,TIME))

 %plot(a(:,TIME))

end