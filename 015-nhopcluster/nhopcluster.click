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

clu::NHopCluster(NODEIDENTITY id,  DISTANCE 2, LINKSTAT device_wifi/link_stat, START 5000, MAXSTARTDELAY 5000);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/03,  //BrnDSR
                           0/0d,  //NHopCluster
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
  
brn_clf[1]
-> Print("Routing-Packet",100)
-> StripBRNHeader()
-> [0]clu[0]
-> Print("out Routing-Packet")
-> BRN2EtherEncap(USEANNO true)
-> [0]dsr;

clu[1]
-> Print("routing-Packet-out")
-> BRN2EtherEncap(USEANNO true)
-> [0]device_wifi;

brn_clf[2]
  -> Discard;

dsr[0]
  -> Label_brnether;
  
dsr[1]
//-> Print("DSR[1]-out")
  -> BRN2EtherEncap()
  -> SetEtherAddr(SRC deviceaddress)
//-> Print("DSR-Ether-OUT")
  -> [0]device_wifi;
  
Idle
-> [1]device_wifi;

Script(
  wait 30,
  read clu.info,
  wait 1,
  stop
);

