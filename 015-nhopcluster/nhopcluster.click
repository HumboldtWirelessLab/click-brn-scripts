#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/routing.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

routing::ROUTING(ID id, ETTHERADDRESS deviceaddress, LT lt, METRIC device_wifi/etx_metric, LINKSTAT device_wifi/link_stat);

clu::NHopCluster(NODEIDENTITY id,  DISTANCE 2, LINKSTAT device_wifi/link_stat, START 5000, MAXSTARTDELAY 5000);

Idle
  -> dc::DCluster(NODEIDENTITY id, LINKSTAT device_wifi/link_stat, DISTANCE 1, DEBUG 4)
  -> Discard;
    
device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_DSR,          //BrnDSR
                           0/BRN_PORT_NHOPCLUSTER,  //NHopCluster
                             -  );//other
				 
routing[0] -> [0]device_wifi;
routing[1] -> [1]device_wifi;
routing[2] -> Label_brnether;
routing[3] -> Discard;
			 
Idle -> [0]routing;
brn_clf[0] -> [1]routing;
Idle -> [2]routing;      //no error, so Idle as input
Idle -> [3]routing;
				 
device_wifi[1] -> BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;
				 

brn_clf[1]
-> Print("Routing-Packet",100)
-> BRN2Decap()
-> [0]clu[0]
-> Print("out Routing-Packet")
-> BRN2EtherEncap(USEANNO true)
-> [0]routing;

clu[1]
-> Print("routing-Packet-out")
-> BRN2EtherEncap(USEANNO true)
-> [0]device_wifi;

brn_clf[2] -> Discard;

Script(
  wait 30,
  read clu.info,
  wait 1,
  stop
);

