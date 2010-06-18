#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev.click"
#include "routing/broadcastrouting.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITIY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

bcr::BROADCASTROUTING(id, deviceaddress, lt);

device_wifi[0]
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
//-> Print("Foo",100)
  -> brn_clf::Classifier( 0/BRN_PORT_FLOODING,  //SimpleFlooding
                          0/BRN_PORT_FLOW,      //SimpleFlow
                            -  );//other
                                    
device_wifi[1]
//-> Print("BRN-In")
  -> Label_brnether;

device_wifi[2]
//-> Print("BRN-In")
  -> Discard;

brn_clf[0] 
//-> Print("SimpleFlood-Ether-IN")
  -> [1]bcr;

brn_clf[1]
//-> Print("rx")
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS 00:0f:00:00:0f:00,
//-> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS ff:ff:ff:ff:ff:ff,
                        RATE 500 , SIZE 100, MODE 0, DURATION 20000,ACTIVE 0)
  -> BRN2EtherEncap()
//-> Print("Raus damit")
  -> [0]bcr;

brn_clf[2]
  -> Discard;

bcr[0]
//-> Print("juhuhuhu")
  -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
  
bcr[1]
  -> [0]device_wifi;

Idle
-> [2]bcr;

toMeAfterDsr[0]
//-> Print("DSR-out: For ME")
  -> Label_brnether;
    
toMeAfterDsr[1]
//-> Print("DSR-out: Broadcast")
  -> Label_brnether;

toMeAfterDsr[2]
//-> Print("DSR-out: Foreign/Client")
  -> [1]device_wifi;

Script(
//  write sf.add_flow 00:0f:00:00:00:00 00:0f:00:00:0f:00 1000 100 0 20000 1,
  write  sf.active 1,
  wait 10,
  read  sf.txflows,
  read  sf.rxflows
);

Script(
  wait 12,
  stop
);
