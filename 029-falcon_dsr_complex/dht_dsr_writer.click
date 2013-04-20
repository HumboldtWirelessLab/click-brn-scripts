#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "dht/routing/dht_falcon.click"
#include "dht/storage/dht_storage.click"
#include "routing/dsr.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable::BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
routingalgo::Dijkstra(NODEIDENTITY id, LINKTABLE lt, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 4);
routingmaint::RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dsr::DSR(id,lt,device_wifi/etx_metric,routingmaint);

dhtrouting::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 170000, UPDATEINT 2000, DEBUG 4);

dhtstorage :: DHT_STORAGE( DHTROUTING dhtrouting/dhtrouting, DEBUG 4 );
dhtstoragetest :: DHTStorageTest( DHTSTORAGE dhtstorage/dhtstorage , STARTTIME 165000, INTERVAL /*1000*/2500, COUNTKEYS 4/*10*/, WRITE true, RETRIES 1, REPLICA 0, DEBUG 2);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_DSR,  //BrnDSR
                           0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                             -  );//other
                                    
brn_clf[0] -> /*Print("DSR-Packet") -> */ [1]dsr;

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

Idle -> [2]dsr;
Idle -> [3]dsr;
Idle -> [4]dsr;

brn_clf[1]
//-> Print("Routing-Packet")
-> BRN2Decap()
-> [0]dhtrouting[0]
-> dht_r_all::Counter()
//-> Print("out Routing-Packet")
-> [0]dsr;

brn_clf[2]
//-> Print("Storage-Packet")
-> BRN2Decap()
-> dhtstorage
-> dht_s::Counter()
//-> Print("Storage-Packet-out",100)
-> [0]dsr;


brn_clf[3] -> Discard;

dhtrouting[1]
//-> Print("routing-Packet-out")
-> dht_r_neighbour::Counter()
-> [0]device_wifi;

dsr[0] -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
dsr[1] -> SetEtherAddr(SRC deviceaddress)/*-> Print("DSR-Ether-OUT")*/ -> [0]device_wifi;

toMeAfterDsr[0] -> /*Print("DSR-out: For ME") ->*/ Label_brnether; 
toMeAfterDsr[1] -> /*Print("DSR-out: Broadcast") ->*/ Discard;
toMeAfterDsr[2] -> /*Print("DSR-out: Foreign/Client") ->*/ [1]device_wifi;

Script(
  wait 150,
  read lt.links,
  wait 19,
  read  dhtrouting/dhtrouting.routing_info,
  wait 1,
  write dhtrouting/dhtnws.start_request 1,
  wait 29,
  read  dhtstorage/dhtstorage.stats,
  read  dhtstoragetest.stats,
  
  //read dht_r_all.count,
  read dht_r_all.byte_count,
  //read dht_r_neighbour.count,
  //read dht_r_neighbour.byte_count,
  //read dht_s.count,
  //read dht_s.byte_count,
  
  read dhtrouting/dhtnws.networksize,
  //read dht/dhtrouting.node_id
  //write dht/dhtrouting.node_id 4cab32f321fc670bf5859c244c790d8b 128
);
