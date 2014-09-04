function backoff_sim(single_bo,no_nodes)
  %single_bo = 1;
  %no_nodes=3;
  no_sims=10000;
  no_transmissions=1000;
  max_backoff=92;

  %a=randi(15,20000000,2);
  %b=find(a(:,1) == a(:,2));
  %c=size(b,1)/20000000
  %size(b)

  max_backoff_1=64;
  max_backoff_2=128;

  backoff_thrshold = 0.5
  backoff_thrshold = (max_backoff - max_backoff_1)/(max_backoff_2-max_backoff_1)

  cur_backoff = zeros(no_nodes,no_sims);

  short_wait_time = zeros(1,no_sims);
  wait_time = zeros(no_nodes,no_sims);
  collisions = zeros(1,no_sims);
  cnt_collisions = zeros(1,no_sims);


  for i = 1:no_transmissions
    if ( single_bo == 1 )
      new_bo = randi(max_backoff,no_nodes,no_sims);                 %neue bo bestimmen
    else
			bo_value_1 = randi(max_backoff_1,no_nodes,no_sims);			
			bo_value_2 = randi(max_backoff_2,no_nodes,no_sims);
			
			max_backoff_sel = rand(no_nodes,no_sims);
			bo_value_1(find(max_backoff_sel < backoff_thrshold)) = 0;
			bo_value_2(find(max_backoff_sel >= backoff_thrshold)) = 0;
			
			new_bo = bo_value_1 + bo_value_2;
	  end

    no_bo = find(cur_backoff(:) > 0);                           %noch rest bo 
    new_bo(no_bo) = 0;                                          %dann hier nicht neu setzen
    cur_backoff = cur_backoff+new_bo;                           %beim rest setzen
    wait_time = wait_time+new_bo;

    min_bo = min(cur_backoff);                                  %min bo für jede sim
    short_wait_time = short_wait_time + min_bo;                 %abziehen
    cur_backoff = cur_backoff - repmat(min_bo,[no_nodes 1]);    % -> mind. einer 0 pro sim

    zero_bo = zeros(no_nodes,no_sims);
    zero_bo(find(cur_backoff(:) == 0)) = 1;
    no_zero_bo = sum(zero_bo);

    col = find(no_zero_bo(:) > 1);
    
    collisions(col) = collisions(col) + 1;
    cnt_collisions = cnt_collisions + no_zero_bo;
  
    %cur_backoff = zeros(no_nodes,no_sims);
  end

  avg_col = sum(collisions) / (no_transmissions * no_sims)
  avg_cnt_col = sum(cnt_collisions) / (no_transmissions * no_sims)
  avg_short_wait_time= sum(short_wait_time) / (no_transmissions * no_sims)
  avg_wait_time = sum(sum(wait_time)) / (no_transmissions * no_sims * no_nodes)

end
