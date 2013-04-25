
 Idle
  -> sf::BRN2SimpleFlow(CLEARPACKET true)
  -> BRN2EtherEncap(USEANNO true)
  //-> Print("Raw")
  -> fcsrc::FlowControlSource(ETHERANNOS false, DEBUG 4)
  -> BRN2EtherEncap(USEANNO true)
  -> rs::RandomSwitch();
  
  sps::SimplePrioSched();

  rs[0] -> /*Print("0") ->*/ sq0::SimpleQueue(200) -> [0]sps;
  rs[1] -> /*Print("1") ->*/ sq1::SimpleQueue(200) -> [1]sps;
  rs[2] -> /*Print("2") ->*/ sq2::SimpleQueue(200) -> [2]sps;

  sps
  -> sup::Suppressor()
  -> Unqueue()
  -> RandomSample(0.2)
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> fcsnk::FlowControlSink(DEBUG 4)
  -> BRN2EtherEncap(USEANNO true)
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> sf2::BRN2SimpleFlow(CLEARPACKET true)
  -> Discard

   fcsnk[1]
  -> BRN2Decap()
  -> [1]fcsrc;
 


Script(
  //write sup.active0 0,
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 100 1000 0 1000 true,
  wait  1,
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 100 1000 0 1000 false,
  //write sup.active0 1,
  wait  10,
  read  sf.stats,
  read  sf2.stats,
  stop
);
