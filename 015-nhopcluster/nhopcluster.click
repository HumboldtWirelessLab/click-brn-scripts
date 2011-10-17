#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/dsr.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dsr::DSR(id,lt,device_wifi/etx_metric);

clu::NHopCluster(NODEIDENTITY id,  DISTANCE 2, LINKSTAT device_wifi/link_stat, START 5000, MAXSTARTDELAY 5000);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_DSR,          //BrnDSR
                           0/BRN_PORT_NHOPCLUSTER,  //NHopCluster
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

Idle
  -> [3]dsr;
  
brn_clf[1]
-> Print("Routing-Packet",100)
-> BRN2Decap()
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

