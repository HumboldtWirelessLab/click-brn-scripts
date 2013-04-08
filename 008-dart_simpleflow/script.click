Script(
  wait 30,
  //read lt.links,
  wait 70,
  read lt.links,
  //read dht/dhtrouting.routing_info,
  wait 20,
  //read  dhtstorage.db_size,
  //read  dhtstoragetest.stats,
  read  dht/dhtrouting/dhtrouting.routing_info,
  wait 10,
  //read  dhtstorage/dhtstorage.db_size,
  //read  dhtstoragetest.stats,
  //read  dht/dhtrouting.routing_info
  //read dht_r_all.count,
  //read dht_r_all.byte_count,
  //read dht_r_neighbour.count,
  //read dht_r_neighbour.byte_count,
  //read dht_s.count,
  //read dht_s.byte_count,
  read  sf.stats
);
