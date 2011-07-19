dev::BRN2Device(DEVICENAME "dummydev", ETHERADDRESS 00:00:00:00:00:01, DEVICETYPE "WIRELESS");
id::BRN2NodeIdentity(NAME dummy, DEVICES dev);

//com::BrnCompoundHandler(HANDLER "dev.deviceinfo id.info", /* CLASSES "BRN2Device BRN2NodeIdentity", CLASSESHANDLER "debug",*/ UPDATEMODE 0, DEBUG 4);
com::BrnCompoundHandler(HANDLER "dev.deviceinfo id.info", /* CLASSES "BRN2Device BRN2NodeIdentity", CLASSESHANDLER "debug",*/ UPDATEMODE 2, RECORDMODE 1, RECORDSAMPLES 5, SAMPLETIME 100, DEBUG 2);


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


Script(
/*  read dev.deviceinfo,
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
  read com.read,*/
//read com.handler,
//read ph.handler,
  wait 1,
/*write ph.period 1000,
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
  wait 2,*/
  read com.read, 
  wait 1,
  read com.read, 
//wait 1000,
  stop
);

ControlSocket(tcp, 7777);
