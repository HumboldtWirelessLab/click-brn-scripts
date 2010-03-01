#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev.click"
#include "routing/geor.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITIY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

geor::GEOR(id, lt, device_wifi/link_stat); 

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
//-> Print("Foo",100)
  -> tothisnode::BRN2ToThisNode(NODEIDENTITY id)
  -> brn_clf::Classifier(    0/14,  //Geor
                           0/10,  //SimpleFlow
                             -  );//other

tothisnode[1] 
  -> brn_clf;

tothisnode[2]
  -> Discard;

Idle
  -> [1]device_wifi;

brn_clf[0]
  -> [1]geor;

geor[0]
//-> Print("GOT PACKET")
  -> Label_brnether;

geor[1]
  -> [0]device_wifi;;

brn_clf[1]
  -> StripBRNHeader()
  -> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS 00:0f:00:00:03:00,
                        RATE 1000 , SIZE 100, MODE 0, DURATION 20000,ACTIVE 0)
  -> BRN2EtherEncap(USEANNO true)
  -> [0]geor;

brn_clf[2]->Discard;
                                    
device_wifi[1]
//-> Print("BRN-In")
  -> Discard;

device_wifi[2]
//-> Print("BRN-In")
  -> Discard;

Idle
  ->[2]geor;
