function a = get_set_bits(i)

  b=1;
  v=1;
  a=[];
  
  while ( v <= i )
    if ( bitget(i,b) == 1 )
      a = [ a; b ];
    end
    v = 2 * v;
    b = b + 1;
  end

end
