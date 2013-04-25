 Idle
  -> sf::BRN2SimpleFlow(CLEARPACKET true)
  -> BRN2EtherEncap(USEANNO true)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> WepEncap(KEY "doener", KEYID 0, ACTIVE true, DEBUG true)
  -> Print("WEP",100)
  -> PrintWifi()
  -> WepDecap(KEY "doener", KEYID 0)
  -> WifiDecap()
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> sf2::BRN2SimpleFlow(CLEARPACKET true)
  -> Discard;
  
Script(
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 5 100 0 1000 true,
  wait  1,
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 5 100 0 1000 false,
  read  sf.stats,
  read  sf2.stats,
  stop
 
);
