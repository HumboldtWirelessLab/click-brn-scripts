#define DEBUGLEVEL 2

//#define CST cst
//#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#define PRO_FL
#define BCAST2UNIC

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/broadcast.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

bc::BROADCAST(ID id, LT lt);

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


brn_clf[0] 
  //-> Print("SimpleFlood-Ether-IN")
  -> [1]bc;

brn_clf[1]
  //-> Print("rx")
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  //-> Print("Raus damit")
  -> [0]bc;

brn_clf[2]
  -> Discard;

bc[0]
  //-> Print("Receive")
  -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
  
bc[1]
  //-> Print("Broadcast out")
  -> [0]device_wifi;

Idle
-> [2]bc;

toMeAfterDsr[0]
  //-> Print("DSR-out: For ME")
  -> Label_brnether;
    
toMeAfterDsr[1]
  //-> Print("DSR-out: Broadcast")
  -> Label_brnether;

toMeAfterDsr[2]
  //-> Print("DSR-out: Foreign/Client")
  -> [1]device_wifi;

/* PASSIV (Overhear) */

device_wifi[2]
  //-> Print("BRN-In2")
  -> BRN2EtherDecap()
  -> overhear_brn_clf::Classifier( 0/BRN_PORT_FLOODING,  //SimpleFlooding
                                  -  );//other

  overhear_brn_clf[0]
  -> [3]bc;

  overhear_brn_clf[1]
  -> Discard;

  
  

