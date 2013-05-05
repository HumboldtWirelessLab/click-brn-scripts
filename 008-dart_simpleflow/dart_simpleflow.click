#define DEBUGLEVEL 2
//#define EXPAND_NEIGHBOURHOOD
//#define OPT_ROUTING
#include "config.click"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "dht/dht.click"
#include "routing/routing.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dht::DHT(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 3000, DEBUG 4);
routing::ROUTING(ID id, ETHERADDRESS deviceaddress, LT lt, METRIC device_wifi/etx_metric, LINKSTAT device_wifi/link_stat, DHT dht);

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
routing[2] -> Label_brnether;
routing[3] -> Discard;

brn_clf[0] -> [1]routing;
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

brn_clf[1] -> [0]dht;
brn_clf[2] -> [1]dht;

dht[0] -> Print("DHTBC") -> [0]device_wifi;
dht[1] -> Print("DHTr") -> [0]routing;

brn_clf[3]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(HEADROOM 192, ROUTINGPEEK routing/routing/routing_peek, DEBUG DEBUGLEVEL)
-> SetTimestamp()
-> BRN2EtherEncap(USEANNO true, DEBUG DEBUGLEVEL)
-> [0]routing;

/* PASSIV (Overhear) */

device_wifi[2]
  -> Print("NODENAME: Passive:")
  -> BRN2EtherDecap()
  -> overhear_brn_clf::Classifier( 0/BRN_PORT_ROUTING,  //Routing
                                   -  );//other

  overhear_brn_clf[0]
  -> [3]routing;

<<<<<<< HEAD
brn_clf[3]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(ROUTINGPEEK dart/routing_peek,LT lt, DEBUG 4)
-> BRN2EtherEncap(USEANNO true)
-> Print("Foo")
-> [0]dart;

dart[0] -> [0]device_wifi;
dart[1] -> Label_brnether;

Idle 
->[1]device_wifi;

Idle
-> [2]dart;
//with 80 nodes dart needs 125 seconds for building the overlay
Script(
  wait 50,
  //read lt.links,
  wait 70, 
  read lt.links,
  //read dht/dhtrouting.routing_info,
  wait 20, 
  //read  dhtstorage.db_size,
  //read  dhtstoragetest.stats,
  read  dht/dhtrouting.routing_info,
  wait 10,
  //read  dhtstorage/dhtstorage.db_size,
  //read  dhtstoragetest.stats,
  //read  dht/dhtrouting.routing_info
  //read dht_r_all.count,
  //read dht_r_all.byte_count,
  //read dht_r_neighbour.count,
  //read dht_r_neighbour.byte_count,
  //read dht_s.count,
  //read dht_s.byte_count,
  read  sf.stats
);
=======
  overhear_brn_clf[1]
  -> Discard;

#include "script.click"
>>>>>>> da8e212f1555982d38e78a38b9dbe1f857e47db2
