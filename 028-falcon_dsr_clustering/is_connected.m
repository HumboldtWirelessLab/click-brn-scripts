function c = is_connected(graph)
  nodes=size(graph,1);

  all_nodes=zeros(1,nodes);
  
  all_nodes(1,1)=1;

  old_size=0;
  new_size=1;

  while old_size ~= new_size
    %w = graph(find(all_nodes(:) == 1 ),:)
    %s=sum(graph(find(all_nodes(:) == 1 ),:),1)
    all_nodes=all_nodes + sum(graph(find(all_nodes(:) == 1 ),:),1);
    all_nodes(find(all_nodes(:) > 1 )) = 1;

    old_size=new_size;
    new_size=sum(all_nodes);
  end

  if new_size == nodes
    c=1;
  else
    c=0;
  end

end
