ps::BRN2PacketSource(SIZE 100, INTERVAL 500, MAXSEQ 500000, BURST 1, ACTIVE true)
-> EtherEncap(0x8086, 00:00:00:00:00:01, 00:00:00:00:00:02)
-> WifiEncap(0x00, 0:0:0:0:0:0)
-> rs::SetTXRates(RATE0 2, TRIES0 1, MCS0 false, BW0 0, SGI0 false, GF0 true, FEC0 0, SP0 true, STBC0 false, DEBUG false)
-> BRN2PrintWifi()
-> BrnRadiotapEncap()
-> BrnRadiotapDecap(DEBUG false)
-> SetTXRates(RATE0 2, TRIES0 1, MCS0 false, BW0 0, SGI0 false, GF0 true, FEC0 0, SP0 true, STBC0 false, DEBUG false)
-> BRN2PrintWifi()
-> Discard;


Script(
  wait 1,
  stop
);