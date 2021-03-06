#define BRNFEEDBACK
#define CST cst

#define ROUTING_PERFORMANCE_CNT

#define LINKPROBE_PERIOD   2000
#define LINKPROBE_TAU      50000
#define LINKPROBE_PROBES   "2 1500 24"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/routing.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

routing::ROUTING(ID id, ETHERADDRESS deviceaddress, LT lt, METRIC device_wifi/etx_metric, LINKSTAT device_wifi/link_stat);

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
#endif

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier(    0/BRN_PORT_ROUTING,     //Routing
                             0/BRN_PORT_DCLUSTER );  //dcluster


routing[0] -> [0]device_wifi;
routing[1] -> [1]device_wifi;
routing[2] -> Label_brnether;
routing[3] -> Discard;

brn_clf[0] -> [1]routing;
Idle -> [3]routing;
device_wifi[1] -> Label_brnether;;

device_wifi[3]
  -> ff::FilterFailures()
  -> BRN2EtherDecap()
  -> Classifier( 0/BRN_PORT_ROUTING )
  -> Print("NODENAME: Success")
  -> [4]routing;

ff[1]
  -> BRN2EtherDecap()
  -> Classifier( 0/BRN_PORT_ROUTING )
  -> Print("NODENAME: TX Failed")
  -> [2]routing;

brn_clf[1]
-> BRN2Decap()
-> dc::DCluster(NODEIDENTITY id, LINKSTAT device_wifi/link_stat, DISTANCE 10, DEBUG 4)
-> SetTimestamp()
-> BRN2EtherEncap(USEANNO true, DEBUG DEBUGLEVEL)
-> [0]routing;


/* PASSIV (Overhear) */

device_wifi[2]
  -> BRN2EtherDecap()
  -> overhear_brn_clf::Classifier( 0/BRN_PORT_ROUTING,  //Routing
                                   -  );//other

  overhear_brn_clf[0]
  -> [3]routing;

  overhear_brn_clf[1]
  -> Discard;

Script(
  wait 15,
//  read dc.stats,
  wait 15,
//  read dc.stats,
  wait 400,
  read dc.stats
);
