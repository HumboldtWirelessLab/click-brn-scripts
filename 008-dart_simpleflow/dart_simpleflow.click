 #define EXPAND_NEIGHBOURHOOD
 #define OPT_ROUTING
 
 #define  UINTERVALL 2000
 #define  LINKPROBE_PERIOD 1000



#define DEBUGLEVEL 2
#define DHTDART
#define ROUTINGDART
#define ROUTING_PERFORMANCE_CNT /* muss ganz nach oben*/
#include "config.click"
#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "dht/dht.click"
#include "routing/routing.click"


AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dht::DHT(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 30000, UPDATEINT UINTERVALL, DEBUG 4);
routing::ROUTING(ID id, ETHERADDRESS deviceaddress, LT lt, METRIC device_wifi/etx_metric, LINKSTAT device_wifi/link_stat, DHT dht);

#ifdef ROUTING_PERFORMANCE_CNT
  routing_pkt_cnt::BrnCompoundHandler(HANDLER "routing/routing_in_cnt_mecl.count routing/routing_in_cnt_brn.count routing/routing_in_cnt_passive.count routing/routing_out_cnt_brn.count routing/routing_out_cnt_cl.count routing/routing_out_cnt_me.count routing/routing_out_cnt_bcast.count");
  routing_byte_cnt::BrnCompoundHandler(HANDLER "routing/routing_in_cnt_mecl.byte_count routing/routing_in_cnt_brn.byte_count routing/routing_in_cnt_passive.byte_count routing/routing_out_cnt_brn.byte_count routing/routing_out_cnt_cl.byte_count routing/routing_out_cnt_me.byte_count routing/routing_out_cnt_bcast.byte_count");
#endif

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
#endif

device_wifi
  -> Print("RX")
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier(    0/BRN_PORT_ROUTING,     //Routing
                             0/BRN_PORT_DHTROUTING,  //DHT-Routing
                             0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                             0/BRN_PORT_FLOW );      //Simpleflow


routing[0] -> Print("NODENAME: r0 out:") -> [0]device_wifi;
routing[1] -> Print("NODENAME: r1 out:") -> [1]device_wifi;
routing[2] -> Print("NODENAME: r2 out:") -> Label_brnether;
routing[3] -> Discard;

brn_clf[0] -> [1]routing;
device_wifi[1] -> Label_brnether;

device_wifi[3]
  -> ff::FilterFailures()
  -> BRN2EtherDecap()
  -> Classifier( 0/BRN_PORT_ROUTING )
 // -> Print("NODENAME: Success")
  -> [4]routing;

ff[1]
  -> BRN2EtherDecap()
  -> Classifier( 0/BRN_PORT_ROUTING )
  //-> Print("NODENAME: TX Failed")
  -> [2]routing;

brn_clf[1] -> [0]dht;
brn_clf[2] -> [1]dht;

dht[0] //-> Print("DHTBC") 
-> [0]device_wifi;
dht[1] //-> Print("DHTr")
 -> [0]routing;

brn_clf[3]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(HEADROOM 192, ROUTINGPEEK routing/routing/routing_peek, LINKTABLE lt, DEBUG 4)
-> SetTimestamp()
-> BRN2EtherEncap(USEANNO true, DEBUG DEBUGLEVEL)
-> [0]routing;

/* PASSIV (Overhear) */

device_wifi[2]
//  -> Print("NODENAME: Passive:")
  -> BRN2EtherDecap()
  -> overhear_brn_clf::Classifier( 0/BRN_PORT_ROUTING,  //Routing
                                   -  );//other

  overhear_brn_clf[0]
  -> [3]routing;

  overhear_brn_clf[1]
  -> Discard;

#include "script.click"
