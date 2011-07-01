dev::BRN2Device(DEVICENAME "dummydev", ETHERADDRESS 00:00:00:00:00:01, DEVICETYPE "WIRELESS");
id::BRN2NodeIdentity(NAME dummy, DEVICES dev);

com::BrnCompoundHandler(HANDLER "dev.deviceinfo id.info")

Script(
  // read dev.deviceinfo,
  // read id.info,
  read com.handler,
  stop
);
