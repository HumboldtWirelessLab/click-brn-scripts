dev::BRN2Device(DEVICENAME "dummydev", ETHERADDRESS 00:00:00:00:00:01, DEVICETYPE "WIRELESS");
id::BRN2NodeIdentity(NAME dummy, DEVICES dev);

elementclass FOO {
comp::BrnCompoundHandler(HANDLER "id.info", UPDATEMODE 0, RECORDMODE 0, RECORDSAMPLES 100, SAMPLETIME 100, COMPRESSIONLIMIT 2000, DEBUG 2);
}

foo::FOO();
com::BrnCompoundHandler(HANDLER "id.info", UPDATEMODE 0, RECORDMODE 0, RECORDSAMPLES 100, SAMPLETIME 100, COMPRESSIONLIMIT 2000, DEBUG 4);

Script(
  write com.insert dev.deviceinfo,
  write com.insert com.read,
  write com.insert foo/comp.read,
  write com.insert lll/u,
  read com.handler, 
  stop
);
