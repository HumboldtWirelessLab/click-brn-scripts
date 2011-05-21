Idle
  -> sf_src::BRN2SimpleFlow(SRCADDRESS 00:0f:00:00:01:00, DSTADDRESS 00:0f:00:00:00:00,
                      RATE 10 , SIZE 800, MODE 0, DURATION 2000000, ACTIVE 1, HEADROOM 192, DEBUG 4)

  -> BRN2EtherEncap(USEANNO true)
  -> Print("ETHER-out",150)
  -> pfrag::PacketFragmentation(MAXSIZE 50, DEBUG 4)
  -> Print("Frag out")
  -> BRN2EtherEncap(USEANNO true)
  -> air::Null()
  -> BRN2EtherDecap(USEANNO true)
  -> Print("Frag in")
  -> BRN2Decap()
//  -> Print("Frag in")
  -> PacketDefragmentation(DEBUG 4)
  -> Print("DeFrag out",150)
  -> ethdec::BRN2EtherDecap()
  -> BRN2Decap()
  -> sf_dst::BRN2SimpleFlow(SRCADDRESS 00:0f:00:00:01:00, DSTADDRESS 00:0f:00:00:00:00, RATE 200 , SIZE 500, MODE 0, DURATION 20000, ACTIVE 0)
  -> Discard;
  
  pfrag[1]
  -> ethdec;
  
Script(
  wait 200,
  read  sf_src.txflows,
  read  sf_src.rxflows,
  read  sf_dst.txflows,
  read  sf_dst.rxflows,
  stop
);
