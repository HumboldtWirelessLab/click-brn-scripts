#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev.click"
#include "dht/routing/dht_falcon.click"
#include "dht/storage/dht_storage.click"
#include "routing/hawk.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITIY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 1000, DEBUG 4);
dhtstorage::DHT_STORAGE( DHTROUTING dht/dhtrouting, DEBUG 2 );
routing::HAWK(id, dht/dhtroutingtable, dhtstorage/dhtstorage, dht/dhtrouting, lt, dht/dhtlprh, dht, 4);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                           0/BRN_PORT_HAWK,        //Hawk
                           0/BRN_PORT_FLOW,        //SimpleFlow
                             -  );//other
                                    

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

brn_clf[0]
//-> Print("Routing-Packet",100)
-> BRN2Decap()
-> [0]dht[0]
-> dht_r_all::Counter()
//-> Print("out Routing-Packet")
-> [0]routing;

brn_clf[1]
//-> Print("Storage-Packet")
-> BRN2Decap()
-> dhtstorage
-> dht_s::Counter()
//-> Print("Storage-Packet-out")
-> [0]routing;

brn_clf[2] -> [1]routing;

brn_clf[4] -> Discard;

dht[1]
//-> Print("routing-Packet-out")
-> dht_r_neighbour::Counter()
-> [0]device_wifi;

brn_clf[3]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS 00:0f:00:00:08:00, RATE 100 , SIZE 100, MODE 0, DURATION 20000, ACTIVE 0)
-> BRN2EtherEncap()
-> [0]routing;

routing[0] /*-> Print("Falcon out")*/ -> BRN2EtherEncap(USEANNO true) -> Print("hawk out ether") -> [0]device_wifi;
routing[1] -> Label_brnether;

Idle 
->[1]device_wifi;

Idle
-> [2]routing;

Script(
  wait 20,
  read dht/dhtrouting.routing_info,
  wait 9, 
  read dht/dhtrouting.routing_info,
  wait 10,
  read  sf.txflows,
  read  sf.rxflows,
  read  routing/rt.tableinfo

);
