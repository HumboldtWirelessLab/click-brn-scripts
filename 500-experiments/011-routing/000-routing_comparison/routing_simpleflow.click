#define DEBUGLEVEL 2

#define DSR_ID_CACHE

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#define BRNFEEDBACK

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE true, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
#endif

/* Routing */
#include "routing.click"

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier(  0/ROUTINGPORT,   //BrnRouting
                           0/BRN_PORT_FLOW, //Simpleflow
			      -  );//other
                                    
brn_clf[0]
  -> [1]routing;

device_wifi[1] -> BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;
device_wifi[3] -> ff::FilterFailures() -> Discard;
ff[1] -> BRN2EtherDecap() -> [2]routing;

brn_clf[1]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(HEADROOM 192)
-> BRN2EtherEncap(USEANNO true)
-> [0]routing;

brn_clf[2]
  -> Discard;

routing[0]
  -> toMeAfterRouting::BRN2ToThisNode(NODEIDENTITY id);

routing[1] -> BRN2EtherEncap(SRC deviceaddress, PUSHHEADER false) -> routing_cnt::Counter() -> [0]device_wifi;

toMeAfterRouting[0]
  -> Label_brnether; 
  
toMeAfterRouting[1]
  -> Discard;

toMeAfterRouting[2]
  -> [1]device_wifi;

Idle -> [3]routing;

Idle -> [4]routing;

Script (
  wait 219,
  read routing_cnt.count,
  read routing_cnt.byte_count
);
