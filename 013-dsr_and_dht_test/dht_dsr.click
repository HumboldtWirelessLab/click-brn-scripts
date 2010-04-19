#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev.click"
#include "dht/routing/dht_dart.click"
#include "dht/routing/dht_falcon.click"
#include "dht/routing/dht_klibs.click"
#include "dht/routing/dht_omni.click"
#include "dht/storage/dht_storage.click"
#include "routing/dart.click"
#include "routing/dsr.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITIY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dsr::DSR(id,lt,rc);

//dht::DHT_OMNI(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 1000, DEBUG 2);
//dht::DHT_KLIBS(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 1000, DEBUG 2);
dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 2000, DEBUG 2);
//dht::DHT_DART(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 1000, DEBUG 2);

dhtstorage :: DHT_STORAGE( DHTROUTING dht/dhtrouting, DEBUG 2);
dhtstoragetest :: DHTStorageTest( DHTSTORAGE dhtstorage/dhtstorage, STARTTIME 75000, INTERVAL 1000, COUNTKEYS 10, WRITE false, RETRIES 1, REPLICA 0, DEBUG 2);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_DSR,  //BrnDSR
                           0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                             -  );//other
                                    
brn_clf[0] /*-> Print("DSR-Packet") */ ->  [1]dsr;

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

Idle -> [2]dsr;

brn_clf[1]
//-> Print("Routing-Packet",100)
-> BRN2Decap()
-> [0]dht[0]
-> dht_r_all::Counter()
//-> Print("out Routing-Packet")
-> [0]dsr;

brn_clf[2]
//-> Print("Storage-Packet")
-> BRN2Decap()
-> dhtstorage
-> dht_s::Counter()
//-> Print("Storage-Packet-out")
-> [0]dsr;

brn_clf[3] -> Discard;

dht[1]
//-> Print("routing-Packet-out")
-> dht_r_neighbour::Counter()
-> [0]device_wifi;

dsr[0] -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
dsr[1] /*-> Print("DSR[1]-out")*/ -> BRN2EtherEncap() -> SetEtherAddr(SRC deviceaddress)/*-> Print("DSR-Ether-OUT")*/ -> [0]device_wifi;

toMeAfterDsr[0] -> /*Print("DSR-out: For ME",100) ->*/ Label_brnether; 
toMeAfterDsr[1] -> /*Print("DSR-out: Broadcast") ->*/ Discard;
toMeAfterDsr[2] -> /*Print("DSR-out: Foreign/Client") ->*/ [1]device_wifi;

Script(
  wait 5,
  read  dht/dhtrouting.routing_info,
//read lt.links,
  wait 5,
  read  dht/dhtrouting.routing_info,
//read lt.links,
  wait 59, 
//read  dhtstorage.db_size,
//read  dhtstoragetest.stats,
  read  dht/dhtrouting.routing_info,
  wait 10,
  wait 20,
//  read  dhtstorage/dhtstorage.db_size,
  read  dhtstorage/dhtstorage.stats,
  read  dhtstoragetest.stats,
  //read  dht/dhtrouting.routing_info
//  read dht_r_all.count,
  //read dht_r_all.byte_count,
  //read dht_r_neighbour.count,
  //read dht_r_neighbour.byte_count,
  //read dht_s.count,
  //read dht_s.byte_count,

);
