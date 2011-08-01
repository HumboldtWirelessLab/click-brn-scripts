dev::BRN2Device(DEVICENAME "dummydev", ETHERADDRESS 00:00:00:00:00:01, DEVICETYPE "WIRELESS");
id::BRN2NodeIdentity(NAME dummy, DEVICES dev);

com::BrnCompoundHandler(HANDLER "dev.deviceinfo id.info", UPDATEMODE 0, RECORDMODE 0, RECORDSAMPLES 100, SAMPLETIME 100, COMPRESSIONLIMIT 2000, DEBUG 4);

Script(  
  print "Record Mode 1",
  write com.recordmode 1,
  print "Update Mode 0",
  write com.updatemode 0,
  print "Sample time 10",
  write com.sampletime 10
);


ControlSocket(tcp, 7777);
