#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev.click"
#include "routing/dsr.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITIY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dsr::DSR(id,lt,rc);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/03,  //BrnDSR
                             -  );//other
                                    
brn_clf[0]
//-> Print("DSR-Packet")
  -> [1]dsr;

device_wifi[1] 
//-> Print("BRN-In")
  -> BRN2EtherDecap()
  -> brn_clf;
  
device_wifi[2]
  -> Discard;

Idle         //no error, so Idle as input
  -> [2]dsr;
  
BRN2PacketSource(100, 1000, 30000, 14, 2, 16)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:0f)
  -> [0]dsr;

brn_clf[1]
  -> Discard;


dsr[0]
  -> Discard;
  
dsr[1]
//-> Print("DSR[1]-out")
  -> BRN2EtherEncap()
  -> SetEtherAddr(SRC deviceaddress)
//-> Print("DSR-Ether-OUT")
  -> [0]device_wifi;

Idle
-> [1]device_wifi;


Script(
  wait 8,
  read lt.links,
  wait 1,
  read lt.routes
);
