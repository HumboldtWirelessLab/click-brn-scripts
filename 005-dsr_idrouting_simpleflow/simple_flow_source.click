#define DEBUGLEVEL 2

#define DSR_ID_CACHE

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/dsr.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dsr::DSR(id,lt,rc,device_wifi/etx_metric);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> Print("Foo",100)
-> brn_clf::Classifier(    0/0a,  //BrnDSR
                           0/34,  //SimpleFlow
                             -  );//other
                                    
brn_clf[0] -> /*Print("DSR-Packet") -> */ [1]dsr;

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

Idle -> [2]dsr;

brn_clf[1]
//-> Print("rx")
-> BRN2Decap()
-> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS 00:0f:00:00:03:00,
                      RATE 1000 , SIZE 100, MODE 0, DURATION 20000,ACTIVE 0)
-> BRN2EtherEncap()
//-> Print("Raus damit")
-> [0]dsr;

brn_clf[2] -> Discard;

dsr[0] -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
dsr[1] -> Print("DSR[1]-out") -> BRN2EtherEncap() -> SetEtherAddr(SRC deviceaddress) -> Print("DSR-Ether-OUT") -> [0]device_wifi;

toMeAfterDsr[0] -> /*Print("DSR-out: For ME") ->*/ Label_brnether; 
toMeAfterDsr[1] -> /*Print("DSR-out: Broadcast") ->*/ Discard;
toMeAfterDsr[2] -> /*Print("DSR-out: Foreign/Client") ->*/ [1]device_wifi;

Script(
  wait 5,
  read lt.links,
  wait 5,
  read lt.links,
  wait 29,
  write sf.add_flow 00:0f:00:00:00:00 00:0f:00:00:03:00 1000 100 0 20000 1,
  write  sf.active 1,
  wait 10,
  read  dsr/ridc.cache,
  read  sf.txflows,
  read  sf.rxflows
);
