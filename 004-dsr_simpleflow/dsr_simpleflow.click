#include "config.click"

#define ROUTING_PERFORMANCE_CNT

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/routing.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
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
  -> brn_clf::Classifier(    0/BRN_PORT_ROUTING, //Routing
                             0/BRN_PORT_FLOW );  //Simpleflow


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
-> sf::BRN2SimpleFlow(HEADROOM 192, ROUTINGPEEK routing/routing/routing_peek, LINKTABLE lt, DEBUG DEBUGLEVEL)
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
wait 130,
read routing/routing_pkt_cnt.read,
//read routing/routing_byte_cnt.read
);

#include "script.click"

