#define DEBUGLEVEL 2

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/geor.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

geor::GEOR(id, lt, device_wifi/link_stat); 

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
//-> Print("Foo",100)
  -> tothisnode::BRN2ToThisNode(NODEIDENTITY id)
  -> brn_clf::Classifier( 0/BRN_PORT_GEOROUTING,  //Geor
                          0/BRN_PORT_FLOW,        //SimpleFlow
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
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow()
  -> BRN2EtherEncap(USEANNO true)
  -> [0]geor;

brn_clf[2]->Discard;
                                    
device_wifi[1]
  -> Print("BRN-In")
  -> Discard;

device_wifi[2]
  -> Print("BRN-In")
  -> Discard;

Idle
  ->[2]geor;

Idle
  ->[3]geor;

Script(
  write geor/gps.cart_coord NODEPOSITIONX NODEPOSITIONY NODEPOSITIONZ,
); 