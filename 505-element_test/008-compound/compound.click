dev::BRN2Device(DEVICENAME "dummydev", ETHERADDRESS 00:00:00:00:00:01, DEVICETYPE "WIRELESS");
id::BRN2NodeIdentity(NAME dummy, DEVICES dev);

com::BrnCompoundHandler(HANDLER "dev.deviceinfo id.info", /* CLASSES "BRN2Device BRN2NodeIdentity", CLASSESHANDLER "debug",*/ DEBUG 4);


ph::BrnPushHandler(HANDLER "com.read", PERIOD 500)
-> Print("Foo",1000)
-> pc::PacketCompression(CMODE 0, DEBUG 4)
-> Print("Comp",1000)
-> Discard;

pc[1]
-> Discard;

Script(
  // read dev.deviceinfo,
  // read id.info,
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
  read com.handler,
  wait 1000,
  stop
);

ControlSocket(tcp, 7777);
