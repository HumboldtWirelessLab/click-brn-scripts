#define COMPRESSION_BRN

#ifdef COMPRESSION_BRN

pc::PacketCompression(CMODE 2, DEBUG 2);
pdc::PacketDecompression(CMODE 2, DEBUG 2);

#else

pc::PacketCompression(CMODE 1, DEBUG 2);
pdc::PacketDecompression(CMODE 1, DEBUG 2);

#endif

 Idle
  -> sf::BRN2SimpleFlow(CLEARPACKET true)
  -> BRN2EtherEncap(USEANNO true)
  -> tx_unc_cnt::Counter()
  -> Print("Raw")
  -> pc
  //-> RandomBitErrors(0.001)
  -> tx_com_cnt::Counter()
#ifdef COMPRESSION_BRN
  -> Print("Raw comp full")
  -> BRN2EtherDecap()
  -> BRN2Decap()
#endif
  -> Print("Raw comp")
  -> pdc
  //-> RandomBitErrors(0.00001)
  -> rx_unc_cnt::Counter()
  -> Print("Raw decomp")
#ifndef COMPRESSION_BRN
  -> BRN2EtherDecap()
#endif
  -> BRN2Decap()
  -> sf2::BRN2SimpleFlow(CLEARPACKET true)
  -> Discard

pc[1]
  -> Print("Compression Error (Compression not worthwhile)")
  -> Discard;

pdc[1]
  -> Print("Decompression Error")
  -> Discard;
  
Script(
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 5 1000 0 1000 true,
  wait  5,
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 5 1000 0 1000 false,
  read  sf.stats,
  read  sf2.stats,
  read  tx_unc_cnt.byte_count,
  read  tx_com_cnt.byte_count,
  read  rx_unc_cnt.byte_count,
  stop
  
);
