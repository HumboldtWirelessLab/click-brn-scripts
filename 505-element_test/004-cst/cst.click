 
dummy::BRN2Device(DEVICENAME "dumme", ETHERADDRESS 00:00:00:00:00:01, DEVICETYPE "WIRELESS");


FromDump("dummy.dump", TIMING true, STOP true)
//-> Print()
-> rtap_decap :: BrnRadiotapDecap()
-> cst::ChannelStats(DEVICE dummy, STATS_DURATION 1000, PROCINTERVAL 1000, NEIGHBOUR_STATS true, FULL_STATS false, SAVE_DURATION 1000)
-> BRN2PrintWifi("OKPacket", PRINTHT true, PRINTRXSTATUS true, TIMESTAMP true)
-> Discard;

Script(
  wait 2,
  read cst.stats_xml,
  stop
);