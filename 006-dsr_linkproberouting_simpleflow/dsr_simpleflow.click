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

lpr::LPRLinkProbeHandler(LINKSTAT device_wifi/link_stat, ETXMETRIC device_wifi/etx_metric);

dsr::DSR(id,lt,rc);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
//-> Print("Foo",100)
  -> brn_clf::Classifier(    0/BRN_PORT_DSR,   //BrnDSR
                             0/BRN_PORT_FLOW,  //Simpleflow
                               -  );//other
                                    
brn_clf[0]
  -> Print("DSR-Packet")
  ->  [1]dsr;

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

Idle -> [2]dsr;

brn_clf[1]
//-> Print("rx")
-> BRN2Decap()
-> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS 00:0f:00:00:01:00,
                      RATE 1000 , SIZE 100, MODE 0, DURATION 20000,ACTIVE 0)
-> BRN2EtherEncap()
-> [0]dsr;

brn_clf[2] -> Discard;

dsr[0] -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
dsr[1] /*-> Print("DSR[1]-out")*/ -> BRN2EtherEncap() -> SetEtherAddr(SRC deviceaddress) /*-> Print("DSR-Ether-OUT")*/ -> [0]device_wifi;

toMeAfterDsr[0] -> /*Print("DSR-out: For ME",100) ->*/ Label_brnether; 
toMeAfterDsr[1] -> /*Print("DSR-out: Broadcast") ->*/ Discard;
toMeAfterDsr[2] -> /*Print("DSR-out: Foreign/Client") ->*/ [1]device_wifi;

Script(
  wait 5,
  read lt.links,
  wait 5,
  read lt.links,
  wait 39, 
  read  sf.txflows,
  read  sf.rxflows
);
