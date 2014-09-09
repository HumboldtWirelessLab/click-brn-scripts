a = load('graph_psr_1_100.txt');

experiments = zeros(1000,1);
max_tx = zeros(100,1);

for e = 1:size(experiments)

neighbours = zeros(size(a));

%senkrecht: 

neighbours(find(a(:) ~= 0)) = 1;

has_p = zeros(size(a,1),1);
no_transmissions = zeros(size(a,1),1);

has_p(1) = 1;

while size(find(has_p(:) == 0)) > 0

  neighbours(find(has_p(:) == 1),:) = 0;      %node which has p doesn't matter

  no_neighbours = sum(neighbours);            %no_neighours with no packet
  no_neighbours(find(has_p(:) ~= 1)) = 0;     %no_neighbours of no which have no p doesn't matter

  %choose node with most neighbours who didn't has p
  sender_node = min(find(no_neighbours(:) == max(no_neighbours)));  %choode node, which has p and which has most neighbours
  neighbour_nodes = find(neighbours(:,sender_node) ~= 0);           %get all neighbours of this node

  %sender_node
  %neighbour_nodes

  rx = 0;

  while ( rx == 0 )

    no_transmissions(sender_node) = no_transmissions(sender_node) + 1;

    for n = 1:size(neighbour_nodes)
      p = 100 * rand;
      p_back = 100 * rand;

      if ( ((a(sender_node,neighbour_nodes(n)) >= p) | (a(neighbour_nodes(n), sender_node) >= p)) &
           ((a(sender_node,neighbour_nodes(n)) >= p_back) | (a(neighbour_nodes(n), sender_node) >= p_back)))
        has_p(neighbour_nodes(n)) = 1;
        rx = 1;
      end
    end

  end

  %no_transmissions
  %has_p
  %has_p(min(find(has_p(:) == 0))) = 1;

end

experiments(e) = sum(no_transmissions);
max_tx(e) = max(no_transmissions);
#no_transmissions
#has_p

end


max(experiments)
mean(experiments)
min(experiments)
max(max_tx)
mean(max_tx)
min(max_tx)

figure;
hist(experiments,50)
figure;
hist(max_tx,50)