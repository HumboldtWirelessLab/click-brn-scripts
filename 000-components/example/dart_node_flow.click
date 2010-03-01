#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev.click"
#include "dht/routing/dht_dart.click"
#include "dht/storage/dht_storage.click"
#include "routing/dart.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITIY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dht::DHT_DART(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat);
dhtstorage :: DHT_STORAGE( DHTROUTING dht/dhtrouting );
//dhtstoragetest :: DHTStorageTest( DHTSTORAGE dhtstorage/dhtstorage , STARTTIME 65000, INTERVAL 500, COUNTKEYS 10, STARTKEY 1, WRITE true, DEBUG 2);
dart::DART(id, dht/dhtroutingtable, dhtstorage/dhtstorage, dht/dhtrouting);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/0e,  //DHT-Routing
                           0/0f,  //DHT-Storage
                           0/15,  //DART
                           0/10,  //SimpleFlow
                             -  );//other
                                    

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

brn_clf[0]
//-> Print("Routing-Packet")
-> StripBRNHeader()
-> [0]dht[0]
-> dht_r_all::Counter()
//-> Print("out Routing-Packet")
-> [0]dart;

brn_clf[1]
//-> Print("Storage-Packet")
-> StripBRNHeader()
-> dhtstorage
-> dht_s::Counter()
//-> Print("Storage-Packet-out",100)
-> [0]dart;

brn_clf[2] -> [1]dart;

brn_clf[4] -> Discard;

dht[1]
//-> Print("routing-Packet-out")
-> dht_r_neighbour::Counter()
-> [0]device_wifi;

brn_clf[3] -> StripBRNHeader()
-> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS 00:0f:00:00:0f:00, RATE 100 , SIZE 100, MODE 0, DURATION 20000,ACTIVE 0)
-> BRN2EtherEncap()
-> [0]dart;

dart[0] /*-> Print("Dart out")*/ -> BRN2EtherEncap() /*-> Print("Dart out ether")*/ -> [0]device_wifi;
dart[1] -> Label_brnether;

Idle->[1]device_wifi;

Script(
  wait 5,
//read lt.links,
  wait 5,
//read lt.links,
  write dht/dhtroutemaintenance.activestart true,
  wait 20,
  read  dht/dhtrouting.routing_info,
  wait 39,
//read  dhtstorage.db_size,
//read  dhtstoragetest.stats,
  read  dht/dhtrouting.routing_info,
  wait 1,
//  write dht/dhtnws.start_request 1,
  wait 3,
  write  sf.active 1,
  wait 6,
  read  dhtstorage/dhtstorage.db_size,
  read  dhtstoragetest.stats,
  
  //read  dht/dhtrouting.routing_info
  
  //read dht_r_all.count,
  //read dht_r_all.byte_count,
  //read dht_r_neighbour.count,
  //read dht_r_neighbour.byte_count,
  //read dht_s.count,
  //read dht_s.byte_count,
  
//  read dht/dhtnws.networksize,
  read  sf.txflows,
  read  sf.rxflows

);
