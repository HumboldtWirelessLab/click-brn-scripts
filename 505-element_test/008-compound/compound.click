dev::BRN2Device(DEVICENAME "dummydev", ETHERADDRESS 00:00:00:00:00:01, DEVICETYPE "WIRELESS");
id::BRN2NodeIdentity(NAME dummy, DEVICES dev);

com::BrnCompoundHandler(HANDLER "dev.deviceinfo id.info", UPDATEMODE 0, RECORDMODE 0, RECORDSAMPLES 100, SAMPLETIME 100, COMPRESSIONLIMIT 2000, DEBUG 4);

/*ph::BrnPushHandler(HANDLER "com.read", PERIOD 500)
-> Print("Foo",1000)
-> pc::PacketCompression(CMODE 0, DEBUG 4)
-> Print("Comp",1000)
-> Discard;
*/
/*pc[1]
-> Print("No Comp",1000)
-> Discard;
*/

#define TEST_0

#ifdef TEST_0

Script(
  write com.remove dev.deviceinfo,
  print "Update Mode 0",
  read com.read,
  print "Update Mode 1",
  write com.updatemode 1,
  read com.read,
  read com.read,
  print "Update Mode 2",
  write com.updatemode 2,
  read com.read,
  read com.read,
  print "Update Mode 0",
  write com.updatemode 0,
  read com.read,
  read com.read,
  
  print "Record Mode 1",
  write com.recordmode 1,
  print "Update Mode 0",
  wait 1,  
  read com.read,
  print "Update Mode 1",
  write com.updatemode 1,
  wait 1,  
  read com.read,
  print "Update Mode 2",
  write com.updatemode 2,
  wait 1,
  read com.read,
  print "Update Mode 0",
  write com.updatemode 0,
  wait 1,
  read com.read,
//  print "Sample Count 5",
//  write com.samplecount 5,
//  write com.sampletime 200,
//  wait 1,
//  read com.read,
  print "Sample time 10",
  write com.sampletime 10,
  wait 1,
  read com.read,
  stop
);

#endif

#ifdef TEST_1
Script(
  read dev.deviceinfo,
  read id.info,
  read com.read,
  read com.handler,
  write com.remove dev.deviceinfo,
  read com.read,
  read com.handler,
  write com.insert dev.deviceinfo,
  read com.read,
  read com.handler,
  write com.insert dev.deviceinfo,
  read com.read,
  stop
);
#endif


#ifdef TEST_2
Script(
  wait 1,
  write com.reset,
  read com.read, 
  write com.insert dev.deviceinfo id.info id.class dev.class com.handler,
  wait 1,
  read com.read, 
  stop
);
#endif

#ifdef TEST_3
  wait 1,
  write ph.period 1000,
  read ph.period,
  wait 2,
  write ph.period 0,
  read ph.period,
  wait 2,
  write ph.period 10000,
  read ph.period,
  wait 2,
  write ph.handler,
  read ph.handler,
  wait 2,
  write ph.handler com.read,
  read com.read,
  stop
);
#endif

#ifdef TEST_4

Script(  
  print "Record Mode 1",
  write com.recordmode 1,
  print "Update Mode 0",
  write com.updatemode 0,
  print "Sample time 10",
  write com.sampletime 10
);

#endif


ControlSocket(tcp, 7777);
